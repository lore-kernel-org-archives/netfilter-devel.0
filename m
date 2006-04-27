From: "=?ISO-8859-1?Q?S=E9bastien_LAVEZE?=" <slaveze@gmail.com>
Subject: Libnetfilter_conntrack problems
Date: Thu, 27 Apr 2006 13:55:13 +0200
Message-ID: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
I'm developping an application using the libnetfilter_conntrack
I'm using a 2.16.1 kernel and all libraries compiled with SVN sources.

1) I'm trying to get the events relatives to the destruction of conntracks
It works fine for update events =3D=3D>nfct_open(CONNTRACK,
NF_NETLINK_CONNTRACK_UPDATE)
but not for destroy =3D=3D> nfct_open(CONNTRACK,
NF_NETLINK_CONNTRACK_DESTROY), i never get any event

2) I also would like to work with ids, when i get a conntrack via a
callback the id field is always set to zero, is it normal ?

Thanks
Sebastien
