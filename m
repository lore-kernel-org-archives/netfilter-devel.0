From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: [libnetfilter_queue] extra data after payload
Date: Sat, 24 Sep 2011 10:08:45 +0200
Message-ID: <j5k36d$9ch$1@dough.gmane.org>
References: <j5ibim$sen$1@dough.gmane.org> <6F5DE7538AFCDA45A114F5E7510424A702B36A0B@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42991 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1IXIJA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:09:00 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R7NIB-0003FE-Eq
	for netfilter-devel@vger.kernel.org; Sat, 24 Sep 2011 10:08:59 +0200
Received: from p4fdf5923.dip.t-dialin.net ([79.223.89.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Sep 2011 10:08:59 +0200
Received: from for-gmane by p4fdf5923.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Sep 2011 10:08:59 +0200
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A702B36A0B@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jeff Haran wrote, On 2011-09-23 19:17:
>> -----Original Message-----
>> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
>> owner@vger.kernel.org] On Behalf Of U.Mutlu
>> Sent: Friday, September 23, 2011 9:20 AM
>> To: netfilter-devel@vger.kernel.org
>> Subject: [libnetfilter_queue] extra data after payload
>>
>> Hi,
>>
>> when reading queue data via the recv() function
>> then one gets a return value much longer than the payload data,
>> so there are some extra data after the payload.
>> What kind of extra data is it?
>>
>> for example:
>>     rv  = recv(fd, buf, sizeof(buf), 0);   // rv=84
>>     ...
>>     ret = nfq_get_payload(tb,&data);      // ret=40 (ie. ip + tcp pkt, both w/o
>> options, and tcp w/o user data)
>>
>> So, here, what are the extra 44 bytes after the tcp data?
>
> I believe you will find there is a struct nlmsghdr at  the beginning of the data, before the IP header, followed by other netlink structures. Take a look at net/netfilter/nfnetlink_queue.c:nfqnl_build_packet_message() in your kernel source tree for the details. The messages containing packets contain a 768 in the (struct nlmsghdr *)->nlmsg_type field at the beginning of the message, which corresponds to NFNL_SUBSYS_QUEUE<<  8 | NFQNL_MSG_PACKET.
>
> Note there appear to be other message types on these sockets. I've seen messages with nlmsg_type == 0 coming off these NFQUEUE sockets too, which apparently contain something other than IP packets and for which you won't get a callback when you call nfq_handle_packet(). So your code shouldn't depend on a 1 to 1 relationship between calls to nfq_handle_packet() and the callback you register via nfq_create_queue().
>
> At least that's what I've observed after having spent the last couple of days playing with this.

nlmsghdr has size 16, I've not figured out yet what comes after it before the (optional) payload starts.
There are some interessting other fields besides len and type, in nlmsghdr, like pid,
but they seem to be not filled.
On my system I found it under the kernel sources:
debian/linux-headers-2.6.37.6-my1a/usr/src/linux-headers-2.6.37.6-my1a/include/linux/netlink.h

Studying the sources is not easy, too low level stuff in libnfnetlink.

Ok, I see some of the extra data can be accessed via the "Message parsing functions":
u_int32_t 	nfq_get_indev (struct nfq_data *nfad)
int 	nfq_get_indev_name (struct nlif_handle *nlif_handle, struct nfq_data *nfad, char *name)
struct nfqnl_msg_packet_hdr * 	nfq_get_msg_packet_hdr (struct nfq_data *nfad)
uint32_t 	nfq_get_nfmark (struct nfq_data *nfad)
u_int32_t 	nfq_get_outdev (struct nfq_data *nfad)
int 	nfq_get_outdev_name (struct nlif_handle *nlif_handle, struct nfq_data *nfad, char *name)
struct nfqnl_msg_packet_hw * 	nfq_get_packet_hw (struct nfq_data *nfad)
int 	nfq_get_payload (struct nfq_data *nfad, unsigned char **data)
u_int32_t 	nfq_get_physindev (struct nfq_data *nfad)
int 	nfq_get_physindev_name (struct nlif_handle *nlif_handle, struct nfq_data *nfad, char *name)
u_int32_t 	nfq_get_physoutdev (struct nfq_data *nfad)
int 	nfq_get_physoutdev_name (struct nlif_handle *nlif_handle, struct nfq_data *nfad, char *name)
int 	nfq_get_timestamp (struct nfq_data *nfad, struct timeval *tv)
int 	nfq_snprintf_xml (char *buf, size_t rem, struct nfq_data *tb, int flags)


