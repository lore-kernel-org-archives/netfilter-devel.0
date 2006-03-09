From: "David Vogt" <beunlovable@gmail.com>
Subject: libipq does not shorten package
Date: Thu, 9 Mar 2006 14:30:06 +0100
Message-ID: <859616420603090530p24d0cb9cg@mail.gmail.com>
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

Dear all,

I already posted this question on netfilter mailing list, however, I
got no response, so maybe someone around here can help me.

I am using iptables and queue packets to user space. Packets are
either augmented (with a signature) or shortened (removal of
signature). The augmentation works.
 However, when removing the signature, the resulting packet contains
the correct data, but its overall size is equal to the original
(signed) packet. (i.e. original packet size: 83, signed packet size:
163)

 I checked this using ethereal on the receiving machine, which lists
packets with the additional bytes (163-83=3D79) as trailer for the
ethernet frame. (So, actually, the packet is processed correclty on
the other side, however, the additional bytes seem odd to me)

I am using iptables 1.2.9 which is - admittedly - not the newset
available, maybe there already has been a fix concerning this? I
haven't updated iptables yet, since the target platform is somewhat
limited and not fully under my control.

 Any help would be great.
