From: Rich Wellner <netfilter@objenv.com>
Subject: Re: trouble with expect_related
Date: Mon, 06 Jan 2003 09:58:41 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <t2mwulie0cu.fsf@rw2-laptop.wellner.org>
References: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
	<1041651291.1637.41.camel@exile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1041651291.1637.41.camel@exile> ("Filip Sneppe's message of
 "04 Jan 2003 04:34:45 +0100")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

"Filip Sneppe (Cronos)" <filip.sneppe@cronos.be> writes:

> However, the oldnat stuff you based your conntracker 
> on should be able to add your expectations without
> any problems, so your problem will probably not get
> solved by moving to the newnat API.

Right, makes sense.  I can't see what's wrong with my code, seems like it
should just work.  Unfortunately, switching kernel isn't an option, I have to
support the 2.4 series with my module, not just the most current stuff.  

Can anyone else comment?

rw2
