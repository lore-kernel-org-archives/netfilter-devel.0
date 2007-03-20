From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:25:25 +0100
Message-ID: <45FFFCE5.6030705@netfilter.org>
References: <45FFF8C3.9050606@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
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

Hi Sebastien,

Sebastien Tandel wrote:
>    I'm wondering if bloom filters could not improve performance of the
> conntracker. For a quick overwiew of bloom filters see
> http://www.eecs.harvard.edu/~michaelm/NEWWORK/postscripts/BloomFilterSurvey.pdf

Yes, I know that work.

> In a few words, a bloom filter is a data structure which represents
> concisely a set. When you have a set, you can decide very quickly if an
> element belongs to it.
> 
> I was then wondering if we could not get rid of these two
> list_for_each_entry in the __nf_conntrack_confirm by using the bloom
> filters.

We can't just get rid of it since bloom filters have false positives, so 
it could happen that we could miss some new connections that are not 
actually in the conntrack table.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
