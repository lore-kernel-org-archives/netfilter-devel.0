From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Sample POM adding packet value field?
Date: Wed, 30 Jun 2004 10:26:02 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630172602.333.qmail@web13902.mail.yahoo.com>
References: <Pine.LNX.4.44.0406301859020.12023-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0406301859020.12023-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Very true, but what I was looking for is an existing
POM item which did that, namely extend the skbuff and
such to provide an extra field (I assume in a patch
and support routines), kinda like 'if MARK was
distributed via POM'...something to help me see what
needs to get patched where to add some skbuff
persistent data.
Do you know if CONNMARK actually extends skbuff or
does it play with connection tracking structures?
-Scott



--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Wed, 30 Jun 2004, Scott MacKay wrote:
> 
> > Are there any POM additions which would add a data
> > field to packets, much like how MARK does?
> 
> No, there simply is no fields available in the
> skbuff for this..
> 
> What there is is CONNMARK which adds per-connection
> mark attributes within 
> netfilter.
> 
> There is also a proposed patch to allow for
> selective bit mask operations 
> on the nfmark (MARK).
> 
> Regards
> Henrik
> 
> 



	
		
__________________________________
Do you Yahoo!?
New and Improved Yahoo! Mail - 100MB free storage!
http://promotions.yahoo.com/new_mail 
