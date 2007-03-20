From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 20:27:12 +0100
Message-ID: <46003590.9070002@netfilter.org>
References: <46000DDF.70509@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Sebastien Tandel <standel@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46000DDF.70509@info.ucl.ac.be>
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

Sebastien Tandel wrote:
> Patrick McHardy wrote:
>> That wouldn't be a big problem in my opinion, you can freely tune the
>> probability.
> 
> In the specific case I was speaking about, you don't expect to find
> anything. Therefore, as Patrick says, if you tune the probability of
> false positives, you should not expect ones really often. If one occurs,
> of course, you have to verify it in the list.

But the case in which we don't expect to find anything is the worst 
case, eg. someone is generating trash traffic to stress the conntrack 
system. So this can be considered as a hardening technique. Anyway, we 
would need to evaluate the impact of such solution in terms of memory 
consumption (probably something from 4KB to 16KB) and extra CPU cycles 
due to hashing. Of course, previously we would have to get some numbers 
to know how bad is currently the worst case.

I have some experimental stuff on bloom filters at my people netfilter 
place that I needed for some works here at the university, it can't be 
used for any productive purposes but you could use it as a starting point.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
