From: Patrick McHardy <kaber@trash.net>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:20:30 +0100
Message-ID: <45FFFBBE.7040407@trash.net>
References: <45FFF8C3.9050606@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Sebastien Tandel <standel@info.ucl.ac.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FFF8C3.9050606@info.ucl.ac.be>
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
>    I'm wondering if bloom filters could not improve performance of the
> conntracker. For a quick overwiew of bloom filters see
> http://www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/BloomFilterSurvey.pdf
> 
> In a few words, a bloom filter is a data structure which represents
> concisely a set. When you have a set, you can decide very quickly if an
> element belongs to it.
> 
> I was then wondering if we could not get rid of these two
> list_for_each_entry in the __nf_conntrack_confirm by using the bloom
> filters.


With a properly sizes hash table the buckets should have only
a single entry on average. The problem with bloom filters is
that its quite expensive to calculate enough hash bits for
a large filter with a low probability of false positives.

> You can use it as a key for a hash table as well. And therefore we may
> use them at a later stage for the hash table as well. But let's see
> first if you're interested by the previous idea ;)
> 
> What do you think?


I thought about using them for caching packet classification results
(DROP/ACCEPT) some time ago. Never got around to try it though.
