From: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>
Subject: Re: problems with libnetfilter_conntrack / cntl_test
Date: Wed, 16 Nov 2005 18:09:24 +0100
Message-ID: <200511161809.25277.pluto@agmk.net>
References: <200511161439.04498.pluto@agmk.net> <437B53E9.2080800@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <437B53E9.2080800@eurodev.net>
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

Dnia =C5=9Broda, 16 listopada 2005 16:44, napisa=C5=82e=C5=9B:
> Pawel Sikora wrote:
> > I have installed a 2.6.14.2 kernel + grsecurity-2.1.7-2.6.14.2-$lates=
t,
> > libnfnetlink-0.0.13 and libnetfilter_conntrack-0.0.28.
> >
> > ./ctnl_test fails:
> >
> > Test for libnetfilter_conntrack
> >
> > NFNETLINK answers: Invalid argument
> > TEST 1: create conntrack (-22)
> > TEST 2: dump conntrack table and reset (-22)
> > TEST 3: dump conntrack table (-22)
> > TEST 4: get conntrack (-22)
> > TEST 5: update conntrack (-22)
> > NFNETLINK answers: Invalid argument
> > TEST 6: delete conntrack (-22)
> > nfnl_open: bind(netlink): Operation not permitted
> > Can't open handler
> > Test failed with error -2. Errors=3D7
> >
> > Is this a grsec issue?
>
> Hard to say, my last contact with grsec was years ago. That output is
> kind of weird. Could you try reverting the grsec patch?

currently I get the same error on 2.6.14.2 without grsec on root account.
first failure occurs at first call of nfnl_talk().

Breakpoint 2, nfnl_talk (nfnlh=3D0x804b0b0, n=3D0xbfcb2680, peer=3D0, gro=
ups=3D0,=20
answer=3D0x0, junk=3D0, jarg=3D0x0)
    at libnfnetlink.c:384
384             struct iovec iov =3D {

(gdb) bt
#0  nfnl_talk (nfnlh=3D0x804b0b0, n=3D0xbfcb2680, peer=3D0, groups=3D0, a=
nswer=3D0x0,
              junk=3D0, jarg=3D0x0)
    at libnfnetlink.c:384
#1  0xb7f84072 in nfct_create_conntrack (cth=3D0x804b0b0, ct=3D0x804b008)
    at libnetfilter_conntrack.c:800
#2  0x08048b89 in main (argc=3D1, argv=3D0xbfcb3804)
    at ctnl_test.c:85

(gdb) p *nfnlh
$1 =3D {fd =3D 6, local =3D {nl_family =3D 16, nl_pad =3D 0, nl_pid =3D 5=
330, nl_groups =3D=20
0}, peer =3D {nl_family =3D 16,
    nl_pad =3D 0, nl_pid =3D 0, nl_groups =3D 0}, subsys_id =3D 1 '\001',=
 seq =3D=20
1132160442, dump =3D 0,
  last_nlhdr =3D 0x0, cb_count =3D 4 '\004', cb =3D 0x804b0f8}

(gdb) p *n
$2 =3D {nlmsg_len =3D 156, nlmsg_type =3D 256, nlmsg_flags =3D 1541, nlms=
g_seq =3D=20
1132160442, nlmsg_pid =3D 0}

(gdb) s
387             struct msghdr msg =3D {
(gdb)
394             memset(&nladdr, 0, sizeof(nladdr));
(gdb)
395             nladdr.nl_family =3D AF_NETLINK;
(gdb)
396             nladdr.nl_pid =3D peer;
(gdb)
397             nladdr.nl_groups =3D groups;
(gdb)
399             n->nlmsg_seq =3D seq =3D ++nfnlh->seq;
(gdb)
401             if (!answer)
(gdb)
402                     n->nlmsg_flags |=3D NLM_F_ACK;
(gdb)
404             status =3D sendmsg(nfnlh->fd, &msg, 0);
(gdb) p msg
$3 =3D {msg_name =3D 0xbfcb0630, msg_namelen =3D 12, msg_iov =3D 0xbfcb06=
18,=20
msg_iovlen =3D 1, msg_control =3D 0x0,
  msg_controllen =3D 0, msg_flags =3D 0}
(gdb) s
405             if (status < 0) {
(gdb)
409             iov.iov_base =3D buf;
(gdb)
410             iov.iov_len =3D sizeof(buf);
(gdb)
413                     status =3D recvmsg(nfnlh->fd, &msg, 0);
(gdb)
414                     if (status < 0) {
(gdb) p status
$4 =3D 36
(gdb) s
420                     if (status =3D=3D 0) {
(gdb)
424                     if (msg.msg_namelen !=3D sizeof(nladdr)) {
(gdb)
430                     for (h =3D (struct nlmsghdr *)buf; status >=3D=20
sizeof(*h); ) {
(gdb)
431                             int len =3D h->nlmsg_len;
(gdb)
432                             int l =3D len - sizeof(*h);
(gdb)
435                             if (l < 0 || len > status) {
(gdb)
444                             if (h->nlmsg_pid !=3D nfnlh->local.nl_pid=
 ||
(gdb)
454                             if (h->nlmsg_type =3D=3D NLMSG_ERROR) {
(gdb)
455                                     struct nlmsgerr *err =3D NLMSG_DA=
TA(h);
(gdb) p *h
$5 =3D {nlmsg_len =3D 36, nlmsg_type =3D 2, nlmsg_flags =3D 0, nlmsg_seq =
=3D 1132160443,=20
nlmsg_pid =3D 5330}


I can provide more info if you need.

BR,

--=20
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke
