From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sat, 23 Jul 2005 17:52:40 +0200
Message-ID: <42E267C8.9090005@trash.net>
References: <42E1ADB2.1080109@trash.net>
	<1122119412.4484.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1122119412.4484.5.camel@localhost.localdomain>
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

Bart De Schuymer wrote:
> Op za, 23-07-2005 te 04:38 +0200, schreef Patrick McHardy:
> 
>>plain text document bijlage (x)
>>[NETFILTER]: Kill ebt_ulog
>>
>>It uses NETLINK_NFLOG, which is also used by ipt_ULOG, so it causes
>>conflicts in netlink_kernel_create. As no userspace daemon exists,
>>and a generic replacement by Harald will follow in the next couple
>>of days, kill it.
> 
> Killing ebt_ulog is not the right thing, it is an ebtables module that
> is used by people (which is why I made it). The right thing would be to
> make ebt_ulog use Harald's upcoming generic code, which is hopefully not
> restricted to iptables.

The upcoming code will be a generic replacement, so there's no need to
have ipt_ULOG/ebt_ulog except for backwards compatiblity reasons.
Is there actually a userspace daemon for ebt_ulog? In any case it makes
little sense to allocate a new netlink number for ebt_ulog since it
will break userspace compatiblity anyway.

Regards
Patrick
