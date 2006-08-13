From: Torsten Luettgert <t.luettgert@cbxnet.de>
Subject: Re: [LARTC] netfilter patch-o-matic: where did all the patches go?
Date: Sun, 13 Aug 2006 23:43:46 +0200
Message-ID: <1155505426.2391.1.camel@murdegern.cbxnet.de>
References: <44D87E89.10706@expertron.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Justin Schoeman <justin@expertron.co.za>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44D87E89.10706@expertron.co.za>
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

On Tue, 2006-08-08 at 14:07 +0200, Justin Schoeman wrote:
> Hi all,
> 
> I haven't been paying attention to this for a while, but now that I 
> download the latest patch-o-matic-ng, I see that most of the patches are 
> gone...

If you're looking for other patches, the last revision before the
removal was 6596. Fetch it like this:

svn co -r 6596 http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng

Regards,
Torsten
