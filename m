Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC68B1BCA1C;
	Thu, 31 Oct 2024 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730391720; cv=none; b=T/z/V9IQOZXvIGh5lGBgQm07YQxbKPv2B+7tXTYu2/pJgAOkDHflOQZMvo/7s89F+Wu6AYY5t6IC8uF7MyH5uK+Wl4xzSdGzWsI+L82t3JsAsjIzz13OymPfJiaibgl22sKtEU/hTvVxTmHRffc4bmV2IgLrB0S+qkmdeH2KJco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730391720; c=relaxed/simple;
	bh=p/bsuflYohrgMd2pyA4rxn/ZvnOCH4iDYm+W5B7U/84=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=A+O+1/SxQJIt75j5liwHztkzYK/9DJw2SRePYmVaIkcVcxtHx7RK0kCqIK9NIDHh3UF9EmtDMtSBxW+2Sm9+qMxmXuh6ir5qPPcgtqyjcyFzMBHgfUkRBhjymSQdXQclY8+mskj3amF1fTJBjw3/i8NYcwMvvwqMracEgxIsY6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4XfTf0017xz6GDty;
	Fri,  1 Nov 2024 00:16:56 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id A16AC140133;
	Fri,  1 Nov 2024 00:21:48 +0800 (CST)
Received: from [10.123.123.159] (10.123.123.159) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 31 Oct 2024 19:21:46 +0300
Message-ID: <62336067-18c2-3493-d0ec-6dd6a6d3a1b5@huawei-partners.com>
Date: Thu, 31 Oct 2024 19:21:44 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 1/8] landlock: Fix non-TCP sockets restriction
Content-Language: ru
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Matthieu Baerts
	<matttbe@kernel.org>
CC: <gnoack@google.com>, <willemdebruijn.kernel@gmail.com>,
	<matthieu@buffet.re>, <linux-security-module@vger.kernel.org>,
	<netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<yusongping@huawei.com>, <artem.kuzin@huawei.com>,
	<konstantin.meskhidze@huawei.com>, MPTCP Linux <mptcp@lists.linux.dev>
References: <20241017110454.265818-1-ivanov.mikhail1@huawei-partners.com>
 <20241017110454.265818-2-ivanov.mikhail1@huawei-partners.com>
 <49bc2227-d8e1-4233-8bc4-4c2f0a191b7c@kernel.org>
 <20241018.Kahdeik0aaCh@digikod.net>
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
In-Reply-To: <20241018.Kahdeik0aaCh@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 mscpeml500004.china.huawei.com (7.188.26.250)

On 10/18/2024 9:08 PM, Mickaël Salaün wrote:
> On Thu, Oct 17, 2024 at 02:59:48PM +0200, Matthieu Baerts wrote:
>> Hi Mikhail and Landlock maintainers,
>>
>> +cc MPTCP list.
> 
> Thanks, we should include this list in the next series.
> 
>>
>> On 17/10/2024 13:04, Mikhail Ivanov wrote:
>>> Do not check TCP access right if socket protocol is not IPPROTO_TCP.
>>> LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP
>>> should not restrict bind(2) and connect(2) for non-TCP protocols
>>> (SCTP, MPTCP, SMC).
>>
>> Thank you for the patch!
>>
>> I'm part of the MPTCP team, and I'm wondering if MPTCP should not be
>> treated like TCP here. MPTCP is an extension to TCP: on the wire, we can
>> see TCP packets with extra TCP options. On Linux, there is indeed a
>> dedicated MPTCP socket (IPPROTO_MPTCP), but that's just internal,
>> because we needed such dedicated socket to talk to the userspace.
>>
>> I don't know Landlock well, but I think it is important to know that an
>> MPTCP socket can be used to discuss with "plain" TCP packets: the kernel
>> will do a fallback to "plain" TCP if MPTCP is not supported by the other
>> peer or by a middlebox. It means that with this patch, if TCP is blocked
>> by Landlock, someone can simply force an application to create an MPTCP
>> socket -- e.g. via LD_PRELOAD -- and bypass the restrictions. It will
>> certainly work, even when connecting to a peer not supporting MPTCP.
>>
>> Please note that I'm not against this modification -- especially here
>> when we remove restrictions around MPTCP sockets :) -- I'm just saying
>> it might be less confusing for users if MPTCP is considered as being
>> part of TCP. A bit similar to what someone would do with a firewall: if
>> TCP is blocked, MPTCP is blocked as well.
> 
> Good point!  I don't know well MPTCP but I think you're right.  Given
> it's close relationship with TCP and the fallback mechanism, it would
> make sense for users to not make a difference and it would avoid bypass
> of misleading restrictions.  Moreover the Landlock rules are simple and
> only control TCP ports, not peer addresses, which seems to be the main
> evolution of MPTCP. >
>>
>> I understand that a future goal might probably be to have dedicated
>> restrictions for MPTCP and the other stream protocols (and/or for all
>> stream protocols like it was before this patch), but in the meantime, it
>> might be less confusing considering MPTCP as being part of TCP (I'm not
>> sure about the other stream protocols).
> 
> We need to take a closer look at the other stream protocols indeed.
Hello! Sorry for the late reply, I was on a small business trip.

Thanks a lot for this catch, without doubt MPTCP should be controlled
with TCP access rights.

In that case, we should reconsider current semantics of TCP control.

Currently, it looks like this:
* LANDLOCK_ACCESS_NET_BIND_TCP: Bind a TCP socket to a local port.
* LANDLOCK_ACCESS_NET_CONNECT_TCP: Connect an active TCP socket to a
   remote port.

According to these definitions only TCP sockets should be restricted and
this is already provided by Landlock (considering observing commit)
(assuming that "TCP socket" := user space socket of IPPROTO_TCP
protocol).

AFAICS the two objectives of TCP access rights are to control
(1) which ports can be used for sending or receiving TCP packets
     (including SYN, ACK or other service packets).
(2) which ports can be used to establish TCP connection (performed by
     kernel network stack on server or client side).

In most cases denying (2) cause denying (1). Sending or receiving TCP
packets without initial 3-way handshake is only possible on RAW [1] or
PACKET [2] sockets. Usage of such sockets requires root privilligies, so
there is no point to control them with Landlock.

Therefore Landlock should only take care about case (2). For now
(please correct me if I'm wrong), we only considered control of
connection performed on user space plain TCP sockets (created with
IPPROTO_TCP).

TCP kernel sockets are generally used in the following ways:
* in a couple of other user space protocols (MPTCP, SMC, RDS)
* in a few network filesystems (e.g. NFS communication over TCP)

For the second case TCP connection is currently not restricted by
Landlock. This approach is may be correct, since NFS should not have
access to a plain TCP communication and TCP restriction of NFS may
be too implicit. Nevertheless, I think that restriction via current
access rights should be considered.

For the first case, each protocol use TCP differently, so they should
be considered separately.

In the case of MPTCP TCP internal sockets are used to establish
connection and exchange data between two network interfaces. MPTCP
allows to have multiple TCP connections between two MPTCP sockets by
connecting different network interfaces (e.g. WIFI and 3G).

Shared Memory Communication is a protocol that allows TCP applications
transparently use RDMA for communication [3]. TCP internal socket is
used to exchange service CLC messages when establishing SMC connection
(which seems harmless for sandboxing) and for communication in the case
of fallback. Fallback happens only if RDMA communication became
impossible (e.g. if RDMA capable RNIC card went down on host or peer
side). So, preventing TCP communication may be achieved by controlling
fallback mechanism.

Reliable Datagram Socket is connectionless protocol implemented by
Oracle [4]. It uses TCP stack or Infiniband to reliably deliever
datagrams. For every sendmsg(2), recvmsg(2) it establishes TCP
connection and use it to deliever splitted message.

In comparison with previous protocols, RDS sockets cannot be binded or
connected to special TCP ports (e.g. with bind(2), connect(2)). 16385
port is assigned to receiving side and sending side is binded to the
port allocated by the kernel (by using zero as port number).

It may be useful to restrict RDS-over-TCP with current access rights,
since it allows to perform TCP communication from user-space. But it
would be only possible to fully allow or deny sending/receiving
(since used ports are not controlled from user space).

Restricting any TCP connection in the kernel is probably simplest
design, but we should consider above cases to provide the most useful
one.

[1] https://man7.org/linux/man-pages/man7/raw.7.html
[2] https://man7.org/linux/man-pages/man7/packet.7.html
[3] https://datatracker.ietf.org/doc/html/rfc7609
[4] https://oss.oracle.com/projects/rds/dist/documentation/rds-3.1-spec.html

> 
>>
>>
>>> sk_is_tcp() is used for this to check address family of the socket
>>> before doing INET-specific address length validation. This is required
>>> for error consistency.
>>>
>>> Closes: https://github.com/landlock-lsm/linux/issues/40
>>> Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
>>
>> I don't know how fixes are considered in Landlock, but should this patch
>> be considered as a fix? It might be surprising for someone who thought
>> all "stream" connections were blocked to have them unblocked when
>> updating to a minor kernel version, no?
> 
> Indeed.  The main issue was with the semantic/definition of
> LANDLOCK_ACCESS_FS_NET_{CONNECT,BIND}_TCP.  We need to synchronize the
> code with the documentation, one way or the other, preferably following
> the principle of least astonishment.
> 
>>
>> (Personally, I would understand such behaviour change when upgrading to
>> a major version, and still, maybe only if there were alternatives to
> 
> This "fix" needs to be backported, but we're not clear yet on what it
> should be. :)
> 
>> continue having the same behaviour, e.g. a way to restrict all stream
>> sockets the same way, or something per stream socket. But that's just me
>> :) )
> 
> The documentation and the initial idea was to control TCP bind and
> connect.  The kernel implementation does more than that, so we need to
> synthronize somehow.
> 
>>
>> Cheers,
>> Matt
>> -- 
>> Sponsored by the NGI0 Core fund.
>>
>>
