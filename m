From: Pablo Neira <pablo@eurodev.net>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Mon, 24 Jan 2005 11:21:51 +0100
Message-ID: <41F4CC3F.7070505@eurodev.net>
References: <200501220013.56429.sov.rbsec@gmail.com>	<20050121233328.GU14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, "Oleg V. Sapon" <sov.rbsec@gmail.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:

>Hi Harald,
>
>On Sat, 22 Jan 2005, Harald Welte wrote:
>
>  
>
>>On Sat, Jan 22, 2005 at 12:13:56AM +0300, Oleg V. Sapon wrote:
>>    
>>
>>> Can you help locate unclean module for 2.6.x kernel or we must use
>>> source files from 2.6.0-test4?
>>>      
>>>
>>I fear nobody did that port to recent 2.6.x and put it into
>>patch-o-matic :(
>>
>>I just did that with the old code from 2.6.0-testX.  I didn't have the
>>time to give it any runtime testing, but at least it compiled (after
>>fixing up some includes).
>>    
>>
>
>I also ported the unclean patch to 2.6 some time ago. The main reason I
>did not post it was the slightly modified API.
>
>The port I created verifies the checksums as well, relying on hardware
>checksums when possible. 
>

Hm, the error API makes sure that we don't start a session in the 
connection tracking with unclean packets (since kernel 2.6.6). So 
something like:

iptables -m state INVALID -j ULOG

should be enough to log evil packets.

The checkings aren't so strict as those that the unclean module used to 
do but with a couple of patches I could tighten that. Actually I 
remember a discussion with Jozsef about this. As far as I can remember 
he didn't like so much the idea of putting half of the unclean module there.

--
Pablo
