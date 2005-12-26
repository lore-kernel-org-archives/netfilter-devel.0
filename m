From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: ongoing textsearch/string match - 3 patches
Date: Mon, 26 Dec 2005 04:50:55 +0100
Message-ID: <43AF689F.2070106@eurodev.net>
References: <18730dc50512220611nfea98e2l88da4f25c97f341d@mail.gmail.com>	
	<43AB2739.6080608@eurodev.net>
	<18730dc50512250828i2f214c8di49c348f03c84593f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amir Goldstein <amir@codefidence.com>
In-Reply-To: <18730dc50512250828i2f214c8di49c348f03c84593f@mail.gmail.com>
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

Amir Goldstein wrote:
> On 12/23/05, Pablo Neira Ayuso <pablo@eurodev.net> wrote:
> 
>>>test:
>>>------
>>>I have tested ongoing string match using netcat UDP connection
>>>and it successfully matched the string:
>>>s
>>>tr
>>>ing
>>
>>So, in this example, my understanding is that you want to find matchings
>> splitted in several packets.
>>
>>>which was sent in different 3 packets.
>>>the netcat test required using --from 28 to skip the udp header and
>>>some test code to ignore the new line characters.
>>
>>I'm curious: We implement matching through fragments with KMP (not for
>>BM yet). So, what kind of application would require such pattern
>>matching policy?
>>
> 
> it's the basics for content filtering in netfilter.
> of course, more work needs to be done:
> - connect this code with connection tracking
> - handle out of order tcp packets

OK. But I'm still in doubt about the usefulness of matching a pattern
between packets. What kind of application splits a request, represented
in the form of a pattern, between packets? Going back to your example:

1st packet) s
2nd packet) tr
3rd packet) ing

Could you comment any realistic scenario?

>>>Index: linux-2.6.14/include/linux/netfilter_ipv4/ipt_string.h
>>>===================================================================
>>>--- linux-2.6.14.orig/include/linux/netfilter_ipv4/ipt_string.h       2005-11-23 19:13:42.000000000 +0200
>>>+++ linux-2.6.14/include/linux/netfilter_ipv4/ipt_string.h    2005-11-23 19:16:38.000000000 +0200
>>>@@ -11,8 +11,10 @@
>>>      char      algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
>>>      char      pattern[IPT_STRING_MAX_PATTERN_SIZE];
>>>      u_int8_t  patlen;
>>>+     u_int8_t  ongoing;
>>>      u_int8_t  invert;
>>>      struct ts_config __attribute__((aligned(8))) *config;
>>>+     struct ts_state __attribute__((aligned(8))) *state;
>>> };
>>
>>Unfortunately, you can't do this. This would break backward
>>compatibility for previous versions of iptables. The correct way to do
>>this is using the matches/targets versioning (see ipt_MARK for an
>>example). We can revisit this later.
>>
> 
> it would take me some time before I can look into the match versioning.
> should I just post the patches as they are now?

Hold on with the versioning stuff. We can do this later if I finally
understand the target of your contribution. Thanks!

-- 
Pablo
