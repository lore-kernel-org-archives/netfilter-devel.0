From: Patrick McHardy <kaber@trash.net>
Subject: Re: bloom filter in netfilter?
Date: Tue, 20 Mar 2007 16:26:34 +0100
Message-ID: <45FFFD2A.9080508@trash.net>
References: <45FFF8C3.9050606@info.ucl.ac.be> <45FFFCE5.6030705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FFFCE5.6030705@netfilter.org>
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

Pablo Neira Ayuso wrote:
>> I was then wondering if we could not get rid of these two
>> list_for_each_entry in the __nf_conntrack_confirm by using the bloom
>> filters.
> 
> 
> We can't just get rid of it since bloom filters have false positives, so
> it could happen that we could miss some new connections that are not
> actually in the conntrack table.


That wouldn't be a big problem in my opinion, you can freely tune the
probability.
