From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: [Bug] OOPS with nf_conntrack_ipv6, probably fragmented UDPv6
Date: Tue, 09 Jan 2007 12:41:19 +0100
Message-ID: <45A37F5F.2030501@birkenwald.de>
References: <459D322F.5010707@birkenwald.de> <45A63D72.2060405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A63D72.2060405@trash.net>
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

Patrick McHardy wrote:

>> I've hit another kernel oops with 2.6.20-rc3 on i386 platform. It is
>> reproducible, as soon as I load nf_conntrack_ipv6 and try to send
>> something large (scp or so) inside an OpenVPN tunnel on my client
>> (patched with UDPv6 transport) the router (another box) OOPSes.
>>
>> tcpdump suggests the problem appears as soon as my client sends
>> fragmented UDPv6 packets towards the destination. It does not happen
>> when nf_conntrack_ipv6 is not loaded. This is the OOPS as dumped from
>> the serial console:
> Does this patch help?

Yes, seems to be working fine.

Can you tell since when this bug is in the kernel?

Regards,
Bernhard
