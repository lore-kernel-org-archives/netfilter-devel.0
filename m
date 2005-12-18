From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ANNOUNCE] Debian packages for libnfnetlink, libnetfilter-{queue,
 log, conntrack}, conntrack
Date: Sun, 18 Dec 2005 18:20:31 +0100
Message-ID: <43A59A5F.1010006@trash.net>
References: <20051127173411.GA2031@roonstrasse.net>
	<438A02D3.3030203@trash.net>
	<20051202102345.GA29691@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20051202102345.GA29691@roonstrasse.net>
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

Max Kellermann wrote:
> On 2005/11/27 20:02, Patrick McHardy <kaber@trash.net> wrote:
> 
>>Very nice, but please wait with trying to get them into
>>sid until we have resolved the CTA_PROTO_NUM issue.
> 
> 
> ok, please notify me when the new release is out.

I've changed libnetlink_conntrack to use the correct type, I guess
we should release this soon. Harald, I'm not familiar with the
process, can you please take care of this?
