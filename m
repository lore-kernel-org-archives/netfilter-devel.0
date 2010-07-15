From: Mistick Levi <gmistick@gmail.com>
Subject: Re: 'HELP ME PLEASE. libnetfilter_queue issue
Date: Thu, 15 Jul 2010 16:44:50 +0300
Message-ID: <AANLkTil_RodsXwi2y8-tOeLsZ8Cl3TN0WYfsAMrrx-VP@mail.gmail.com>
References: <1DB91DF937A4544C81E636468B91C21C06F1EC28@CNSHGSMBS03.ad4.ad.alcatel.com>
	<1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: MAI JIN <Jin.Mai@alcatel-sbell.com.cn>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1DB91DF937A4544C81E636468B91C21C06F1ECAF@CNSHGSMBS03.ad4.ad.alcatel.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,
Where is the Callback function?
( You use it when you call "create_queue" ), w-hen you call
handle_packet() it executes the callback you supply in
"create_queue"..

And messages are removed from the queue only after you issue a verdict
for them. until you do they will eat up you're queue space :)

in order to fix the problem, create a callback ( "cb" is the name you
issued in the create_queue function ) and issue a verdict for the
messages you receive in that callback.

Kind Regards
Yechiel Levi

On Thu, Jul 15, 2010 at 11:08 AM, MAI JIN <Jin.Mai@alcatel-sbell.com.cn=
> wrote:
>
> =A0Hi,
>
> I'm a new user to libnetfilter_queue. I ran the test example of
> libnetfilter_queue-1.0.0 on a Debian x86 (Linux debian 2.6.26-1-686)
> host but I found that the pakcets queue in NFQUEUE were not dequeued
> after recv() was invoked. I ran the iptables command on the debain ho=
st:
> iptables -A INPUT -p udp --dport 8192:32000 -j NFQUEUE --queue-num 0
>
> Then I send UDP packets from another machine with destination port in
> the range. By default, the libnetfilter_queue received 1000 packets o=
n
> Debian host and stopped (blocked in recv()). Then I set the queue len=
gth
> to 12000 nfq_set_queue_maxlen(qh, 1200) . This time, the
> libnetfilter_queue received 1200 packets and stopped (blocked in
> recv()).
>
> Looks like the pakcets were not dequeued from NFQUEUE? How can I fix
> this problem?
>
> int main(int argc, char **argv)
> {
> =A0 =A0 =A0 =A0struct nfq_handle *h;
> =A0 =A0 =A0 =A0struct nfq_q_handle *qh;
> =A0 =A0 =A0 =A0struct nfnl_handle *nh;
> =A0 =A0 =A0 =A0int fd;
> =A0 =A0 =A0 =A0int rv;
> =A0 =A0 =A0 =A0char buf[4096] __attribute__ ((aligned));
>
> =A0 =A0 =A0 =A0printf("opening library handle\n");
> =A0 =A0 =A0 =A0h =3D nfq_open();
> =A0 =A0 =A0 =A0if (!h) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during nfq_open=
()\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printf("unbinding existing nf_queue handler for AF_INE=
T (if
> any)\n");
> =A0 =A0 =A0 =A0if (nfq_unbind_pf(h, AF_INET) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during nfq_unbi=
nd_pf()\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printf("binding nfnetlink_queue as nf_queue handler fo=
r
> AF_INET\n");
> =A0 =A0 =A0 =A0if (nfq_bind_pf(h, AF_INET) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during nfq_bind=
_pf()\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printf("binding this socket to queue '0'\n");
> =A0 =A0 =A0 =A0qh =3D nfq_create_queue(h, =A00, &cb, NULL);
> =A0 =A0 =A0 =A0if (!qh) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "error during nfq_crea=
te_queue()\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printf("setting copy_packet mode\n");
> =A0 =A0 =A0 =A0if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "can't set packet_copy=
 mode\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (nfq_set_queue_maxlen(qh, 1200) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, "can't set queue_maxle=
n\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0fd =3D nfq_fd(h);
>
> =A0 =A0 =A0 =A0while ((rv =3D recv(fd, buf, sizeof(buf), 0)) && rv >=3D=
 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nfq_handle_packet(h, buf, rv);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0printf("unbinding from queue 0\n");
> =A0 =A0 =A0 =A0nfq_destroy_queue(qh);
>
> #ifdef INSANE
> =A0 =A0 =A0 =A0/* normally, applications SHOULD NOT issue this comman=
d, since
> =A0 =A0 =A0 =A0 * it detaches other programs/sockets from AF_INET, to=
o ! */
> =A0 =A0 =A0 =A0printf("unbinding from AF_INET\n");
> =A0 =A0 =A0 =A0nfq_unbind_pf(h, AF_INET);
> #endif
>
> =A0 =A0 =A0 =A0printf("closing library handle\n");
> =A0 =A0 =A0 =A0nfq_close(h);
>
> =A0 =A0 =A0 =A0exit(0);
> }
>
>
> Best regards
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> Mai Jin
> Alcatel Shanghai Bell (Nanjing) Co. Ltd.
> Alcatel-Net: 2735-5011
> Tel: (+86)-25-8473 1240-5011
> Addr: 11F, Yangtse River Tech Park.
> =A0 =A0 =A0 =A0 =A0 Building No.40 of Nanchang Road,
> =A0 =A0 =A0 =A0 =A0 Gulou District, Nanjing, China
> Zip: 210037
> jin.mai@Alcatel-sbell.com.cn
> ASB/MoAD/RDR/BSR APL
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
