From: Filip Sneppe <filip.sneppe@cronos.be>
Subject: Re: trouble with expect_related
Date: 07 Jan 2003 10:50:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1041933003.502.23.camel@xbox>
References: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
	<1041651291.1637.41.camel@exile>  <t2mwulie0cu.fsf@rw2-laptop.wellner.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rich Wellner <netfilter@objenv.com>
In-Reply-To: <t2mwulie0cu.fsf@rw2-laptop.wellner.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2003-01-06 at 16:58, Rich Wellner wrote:
> "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be> writes:
> 
> > However, the oldnat stuff you based your conntracker 
> > on should be able to add your expectations without
> > any problems, so your problem will probably not get
> > solved by moving to the newnat API.
> 
> Right, makes sense.  I can't see what's wrong with my code, seems like it
> should just work.  Unfortunately, switching kernel isn't an option, I have to
> support the 2.4 series with my module, not just the most current stuff.  

No problem.
 
> Can anyone else comment?
> 
Do you see the expected connection in /proc/net/ip_conntrack? It should
be preceded by "EXPECTING:" if it hasn't seen any traffic yet.

Regards,
Filip
