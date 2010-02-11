From: Ramblewski David <David.Ramblewski@atosorigin.com>
Subject: kernel stack  trace using conntrack
Date: Thu, 11 Feb 2010 14:18:38 +0100
Message-ID: <7EF5DBE4C76A7B4DA655334E9F2BFD26BC44DC9E42@FRSPX100.fr01.awl.atosorigin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.mail.atosorigin.com ([160.92.103.80]:56279 "EHLO
	smtp1.mail.atosorigin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0BKNSl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:18:41 -0500
Received: from filter.atosorigin.com (localhost [127.0.0.1])
	by mxfed001 (Postfix) with ESMTP id DC8D22668777
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 14:18:39 +0100 (CET)
Received: from mail.awl.fr.atosorigin.com (serv-smtp-wse02.fr.atosworldline.com [160.92.103.181])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "mail.awl.fr.atosorigin.com", Issuer "VeriSign Class 3 Secure Server CA - G2" (verified OK))
	by mxfed001 (Postfix) with ESMTP id D640E26788B1
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 14:18:39 +0100 (CET)
Content-Language: fr-FR
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Guys,

I'm actually facing an issue using conntrack tools :

The following command:

conntrack -I conntrack -p udp --orig-src 10.24.230.103 --orig-dst 10.24=
=2E230.103 --reply-src 10.24.230.103 --reply-dst 10.24.230.103 --orig-p=
ort-src 20000 --orig-port-dst 20000 --reply-port-src 20000 --reply-port=
-dst 20000 -u ASSURED -t 10

make a kernel call trace:

=46eb 11 10:01:46 obench03s kernel: WARNING: at net/netfilter/nf_conntr=
ack_extend.c:82 __nf_ct_ext_add+0x25/0x1ef [nf_conntrack]()
=46eb 11 10:01:46 obench03s kernel: Hardware name: ProLiant DL380 G5
=46eb 11 10:01:46 obench03s kernel: Modules linked in: nf_conntrack_net=
link nf_conntrack usbhid hpilo hpwdt bnx2 ipmi_si ipmi_msghandler rtc_c=
mos rtc_core rtc_lib ehci_hcd uhci_hcd usbcore dm_mod [last unloaded: i=
pmi_devintf]
=46eb 11 10:01:46 obench03s kernel: Pid: 3786, comm: conntrack Tainted:=
 G        W  2.6.32.8 #1
=46eb 11 10:01:46 obench03s kernel: Call Trace:
=46eb 11 10:01:46 obench03s kernel:  [<c10375b2>] warn_slowpath_common+=
0x60/0x77
=46eb 11 10:01:46 obench03s kernel:  [<c10375d6>] warn_slowpath_null+0x=
d/0x10
=46eb 11 10:01:46 obench03s kernel:  [<f805bb8e>] __nf_ct_ext_add+0x25/=
0x1ef [nf_conntrack]
=46eb 11 10:01:46 obench03s kernel:  [<f80227ff>] ctnetlink_new_conntra=
ck+0x283/0x5ac [nf_conntrack_netlink]
=46eb 11 10:01:46 obench03s kernel:  [<c102a3dd>] ? __wake_up+0x31/0x3b
=46eb 11 10:01:46 obench03s kernel:  [<c1125bcb>] ? jbd_free_handle+0xf=
/0x11
=46eb 11 10:01:46 obench03s kernel:  [<c102105d>] ? default_spin_lock_f=
lags+0x8/0xb
=46eb 11 10:01:46 obench03s kernel:  [<c1451ede>] ? _spin_lock_irqsave+=
0x2b/0x34
=46eb 11 10:01:46 obench03s kernel:  [<c139cefe>] nfnetlink_rcv_msg+0xe=
f/0x115
=46eb 11 10:01:46 obench03s kernel:  [<c11e1284>] ? security_netlink_re=
cv+0xf/0x11
=46eb 11 10:01:46 obench03s kernel:  [<c139ce5e>] ? nfnetlink_rcv_msg+0=
x4f/0x115
=46eb 11 10:01:46 obench03s kernel:  [<c139ce0f>] ? nfnetlink_rcv_msg+0=
x0/0x115
=46eb 11 10:01:46 obench03s kernel:  [<c1399962>] netlink_rcv_skb+0x30/=
0x75
=46eb 11 10:01:46 obench03s kernel:  [<c139ce07>] nfnetlink_rcv+0x17/0x=
1f
=46eb 11 10:01:46 obench03s kernel:  [<c139980b>] netlink_unicast+0xd2/=
0x127
=46eb 11 10:01:46 obench03s kernel:  [<c139a90b>] netlink_sendmsg+0x219=
/0x226
=46eb 11 10:01:47 obench03s kernel:  [<c137d9cc>] __sock_sendmsg+0x45/0=
x4e
=46eb 11 10:01:47 obench03s kernel:  [<c137e116>] sock_sendmsg+0xb8/0xc=
e
=46eb 11 10:01:47 obench03s kernel:  [<c104778f>] ? autoremove_wake_fun=
ction+0x0/0x33
=46eb 11 10:01:47 obench03s kernel:  [<c1027851>] ? kunmap_atomic+0x4f/=
0x6a
=46eb 11 10:01:47 obench03s kernel:  [<c1027986>] ? kmap_atomic+0x14/0x=
16
=46eb 11 10:01:47 obench03s kernel:  [<c107e511>] ? get_page_from_freel=
ist+0x33d/0x3c6
=46eb 11 10:01:47 obench03s kernel:  [<c1204eb3>] ? __copy_from_user_ll=
+0x11/0xce
=46eb 11 10:01:47 obench03s kernel:  [<c137e9ec>] ? move_addr_to_kernel=
+0x39/0x41
=46eb 11 10:01:47 obench03s kernel:  [<c137ea98>] sys_sendto+0xa4/0xc0
=46eb 11 10:01:47 obench03s kernel:  [<c107a706>] ? unlock_page+0xe/0x1=
0
=46eb 11 10:01:47 obench03s kernel:  [<c108acdd>] ? __do_fault+0x310/0x=
343
=46eb 11 10:01:47 obench03s kernel:  [<c108c634>] ? handle_mm_fault+0x3=
17/0x73c
=46eb 11 10:01:47 obench03s kernel:  [<c137f1ba>] sys_socketcall+0xec/0=
x18e
=46eb 11 10:01:47 obench03s kernel:  [<c100874c>] sysenter_do_call+0x12=
/0x28

I'm using these tools:

      libnfnetlink-1.0.0
      libnetfilter_conntrack-0.0.101
      conntrack-tools-0.9.14

Thanks for your feedback.

David



Ce message et les pi=E8ces jointes sont confidentiels et r=E9serv=E9s =E0=
 l'usage exclusif de ses destinataires. Il peut =E9galement =EAtre prot=
=E9g=E9 par le secret professionnel. Si vous recevez ce message par err=
eur, merci d'en avertir imm=E9diatement l'exp=E9diteur et de le d=E9tru=
ire. L'int=E9grit=E9 du message ne pouvant =EAtre assur=E9e sur Interne=
t, la responsabilit=E9 du groupe Atos Origin ne pourra =EAtre recherch=E9=
e quant au contenu de ce message. Bien que les meilleurs efforts soient=
 faits pour maintenir cette transmission exempte de tout virus, l'exp=E9=
diteur ne donne aucune garantie =E0 cet =E9gard et sa responsabilit=E9 =
ne saurait =EAtre recherch=E9e pour tout dommage r=E9sultant d'un virus=
 transmis.

This e-mail and the documents attached are confidential and intended so=
lely for the addressee; it may also be privileged. If you receive this =
e-mail in error, please notify the sender immediately and destroy it. A=
s its integrity cannot be secured on the Internet, the Atos Origin grou=
p liability cannot be triggered for the message content. Although the s=
ender endeavours to maintain a computer virus-free network, the sender =
does not warrant that this transmission is virus-free and will not be l=
iable for any damages resulting from any virus transmitted.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
