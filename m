From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6 0/5]: NAT fixes
Date: Mon, 29 Nov 2004 06:26:35 +0100
Message-ID: <41AAB30B.3080708@trash.net>
References: <41AA5EFC.1080708@trash.net>
	<20041128194231.0985f426.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20041128194231.0985f426.davem@davemloft.net>
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

David S. Miller wrote:

>On Mon, 29 Nov 2004 00:27:56 +0100
>Patrick McHardy <kaber@trash.net> wrote:
>
>  
>
>>the next 5 patches (against your 2.6.11 tree) fix DNAT on loopback and 
>>some issues
>>with locally generated ICMP errors for NATed packets.
>>    
>>
>
>So this means it's OK to push this into 2.6.11 instead of trying
>to slip it into 2.6.10?
>
>It looks like there are not OOPS or crash fixes in here.
>If there are, those would be 2.6.10 candidates.
>

I think they are more 2.6.11 candidates. I've tested them well, but
they don't fix any crashes.

All of the bugs they fix except for parts of the fifth patch (verify
manips have been applied before reversing them) have been there for
ages. The fifth patch fixes a bug (besides multiple others) recently
introduced by my patch "associate locally generated icmp errors with
conntrack of original packet" (ChangeSet@1.2083.2.1), some locally
generated broken ICMP messages (not broken by the patch) can't be
matched with "-m state --state INVALID" anymore. I don't think many
people actually do this, and the patch that introduced the bug still
fixes a different kind of broken ICMP errors.

So we have three options:
1. revert the patch that introduced the latest bug
2. live with the bug in 2.6.10 and put the patches in 2.6.11
3. have me double-check the fifth patch and put it in 2.6.10

I favour the second option, but if you disagree I'm also fine
with double-checking the fifth patch and putting it in 2.6.10.

Regards
Patrick
