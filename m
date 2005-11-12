From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH  1/4] implement get and zero counters
Date: Sat, 12 Nov 2005 14:10:41 +0100
Message-ID: <4375E9D1.1050204@netfilter.org>
References: <43729C84.9010800@netfilter.org>
	<20051112102959.GF10584@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051112102959.GF10584@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Thu, Nov 10, 2005 at 02:04:04AM +0100, Pablo Neira wrote:
> 
>>Add support to zero counters conntrack at getting. Currently we can zero
>>all the conntracks via "zero and dump", but it could be useful more fine
>>grain zeroing.
> 
> but do we really want to add this feature at the expense of _always_
> grabbing a write lock on ip_conntrack_lock?  I don't think so.

OK, in that case I'll rework patch and send it to you soon.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
