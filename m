From: Peteris Krumins <newsgroups@lf.lv>
Subject: Re[2]: where's the definition of function iptc_init
Date: Sun, 15 Jun 2003 21:56:05 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <48263348945.20030615215605@lf.lv>
References: <20030614222629.10196.83157.Mailman@kashyyyk>
 <025e01c332cb$eb958360$0b00a8c0@haf>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <025e01c332cb$eb958360$0b00a8c0@haf>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jack,

Sunday, June 15, 2003, 2:22:49 AM, you wrote:

>> Date: Sat, 14 Jun 2003 17:23:37 +0300
>> From: Peteris Krumins <newsgroups@lf.lv>
>> Reply-To: Peteris Krumins <newsgroups@lf.lv>
>> To: netfilter-devel@lists.netfilter.org
>> Subject: Re: where's the definition of function iptc_init
>> 
>> Saturday, June 14, 2003, 4:19:32 PM, you wrote:
>> 
>> J> (send again in txt format)
>> J> Hi all
>> J> Sorry for disturbing you all
>> J> I just begin to study the source code.
>> J> I could not find the definition of function iptc_init. 
>> J>  Please give me a hint.
>> 
>> man grep
>> 
>> 
>> P.Krumins
>> 
>> 
J> # grep iptc_init * -r

J> I didn't find the define still.

$ pwd
/[...]/iptables-1.2.8

$ grep "iptc_init" * -r
[...]
libiptc/libip4tc.c:#define TC_INIT                      iptc_init

$ grep -n "TC_INIT" ./libiptc/*.c
[...]
./libiptc/libiptc.c:227:TC_INIT(const char *tablename)


P.Krumins
