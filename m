From: Herve Eychenne <rv@wallfire.org>
Subject: RAM and conntrack performance
Date: Tue, 28 Oct 2003 16:10:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031028151032.GD726@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hi everyone,

Can someone post a state of the art summary for netfilter conntrack
(and maybe NAT) performance tweaking?
The only things I'm currently aware of are:
- modprobe ip_conntrack hashsize=3D$HASHSIZE
- echo $CONNTRACK_MAX > /proc/sys/net/ipv4/ip_conntrack_max

I think it would be good to end up with a small document which would
give every detail about how to choose optimal values for HASHSIZE and
CONNTRACK_MAX, and every other mean to get the best out of the
conntracking/NAT system...

Here are things I've collected so far, that it would be good to have
in this little document. I have questions, also:
- CONNTRACK_MAX and HASHSIZE get default values at boot time.
  By default, CONNTRACK_MAX =3D n * 64, where n is the RAM size in MB,
  am I right?
  What about HASHSIZE default value? How to read it at runtime?
  What is the exact link between these 2 values?
- HASHSIZE should be an odd number, and even better: a prime number.
  What happens when you set it to an even number, or a non-prime number?
  Why enable people to set even and non-prime numbers at all?
- Default values are "reasonnable" for a typical host, but we may
  increase them on high-loaded firewalling-only systems, right?
  Which values are the "best"? I.e., can someone give a formula with
  this potential parameters (if pertinent):
  - total RAM size
  - size of the memory that should be left for non-conntrack data in
    the kernel and userspace in general (what is a reasonnable value for
    a firewall doing only firewalling with very few applications
    running, and how to measure that at runtime?)
  - number of rules, connections rate, etc.
- CONNTRACK_MAX can be modified at run time with /proc. What does it
  do exactly (when shinked, when extended)?
  When you modify CONNTRACK_MAX, should you also modify HASHSIZE
  accordingly? Why? How?
- Is it possible to modify HASHSIZE at runtime when ip_conntrack is
  not compiled as a module? If not, shouldn't we enable this with
  /proc, like CONNTRACK_MAX?
- Does any of these operations currently (or possibly, if soon
  implemented) lead to some rehashing at runtime?
  I suppose it would be quite slow... How long does/would it take?
  How to proceed to keep current conntrack entries at runtime as much
  as possible? (I suppose unloading ip_conntrack module and
  reinserting it with another hashsize value clears the table...)

Please comment...

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
