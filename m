From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: RE: Masquerading and loading balancing among several outbound Internet connections
Date: Wed, 2 Jun 2004 10:05:12 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF591E328@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Joseph Tung" <jst1@pacbell.net>,
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Joseph Tung wrote:
> Hello,
>=20
> I have several internal networks that are to be ipmasqueraded or
> snat'd among several outbound Internet connections (all going to this
> one router/bridge).
>=20
> 1) Is it possible to ipmasquerade to more than 1 outbound Internet
> connection? (I have Fedora Core 1).

Yes. Maybe with a kernel update, but yes, its possible

> 2) If so, are there any samples of how this is done?  For now, I'd be
> happy just assigning each private network one outgoing ip address;
> but I want to do this with one box.  Then I'll bridge the two (or
> more) by modifying the routing table?

If you're only using a single ISP, you can get away with something like
the following. This may also work on different ISP's, but that depends
on if they filter your traffic outbound. Some do, some don't.

# Set all new connections to use either of the external network's
interfaces. This is a simple return-path algorithm
iptables -A PREROUTING --destination ! ${INTERNAL}/${MSK_INT} -m state
--state NEW -m nth --every 2 --start 0 -j MARK --set-mark 100
iptables -A PREROUTING --destination ! ${INTERNAL}/${MSK_INT} -m state
--state NEW -m nth --every 2 --start 1 -j MARK --set-mark 101

# This is what 'equalizes' the outgoing data.
iptables -A PREROUTING --destination ! ${INTERNAL}/${MSK_INT} -m state
--state ESTABLISHED,RELATED -m nth --every 2 --start 0 -j MARK
--set-mark 100
iptables -A PREROUTING --destination ! ${INTERNAL}/${MSK_INT} -m state
--state ESTABLISHED,RELATED -m nth --every 2 --start 1 -j MARK
--set-mark 101

# See below
route_builder 100 $ISP_NET1_GW $MY_ISP_NET1_IP
route_builder 101 $ISP_NET2_GW $MY_ISP_NET2_IP

# Use SNAT rules on each outgoing interface

The following script is what I use to easily build specialized routing
tables.
#
# Notes:
#    This function generates a new routing table based on the currect
main
#    routing table. The difference is that the default route is user
specified.
#=20
# Arguments:
#    1 - Table ID to create
#    2 - IP Address, Gateway Address=20
#    3 - IP Address, Generated Source - In other words, your internet
address
#
function route_builder
{
   if [ "${OPT_SYS_ROUTER}" =3D "0" -o "${OPT_ROUTER_POLICYROUTING}" =3D =
"0"
]; then
      info "route_builder: Policy Routing is disabled. Skipping."
      return 1
   fi
   _table_id=3D${1}
   _table_gateway=3D${2}
   _table_source=3D${3}
   if [ ! -z "${_table_id}" -a ! -z "${_table_gateway}" -a ! -z
"${_table_source}" ]; then
      ${IP} rule del fwmark ${_table_id} table ${_table_id}
      ${IP} rule add fwmark ${_table_id} table ${_table_id}
      ${IP} route flush table ${_table_id}
      ${IP} route show table main | grep -Ev ^default
\
      | while read ROUTE ; do  =20
         ${IP} route add table ${_table_id} $ROUTE
      done
      ${IP} route add table ${_table_id} default via ${_table_gateway}
\
         src ${_table_source}
   else
      info "route_builder: Invalid arguments specified."
   fi
}

> 3) I'd like to provide webservices via several low bandwidth
> connections, so I'd like to dynamically route the traffic based on the
> load.  My sense is that this is impossible with the current release.

Take a look at lartc.org and TC and tell us what isn't possible to
traffic shape :-)
