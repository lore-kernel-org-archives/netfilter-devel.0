From: "Richard" <richard@o-matrix.org>
Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
Date: Mon, 13 Dec 2004 11:10:11 -1000
Message-ID: <EINSTEINyo3DjFbUcOV00000275@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: 
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



> -----Original Message-----
> From: Richard [mailto:richard@o-matrix.org]
> Sent: Wednesday, December 08, 2004 3:48 PM
> To: 'Pablo Neira'
> Cc: 'netfilter-devel@lists.netfilter.org'
> Subject: RE: [NEW TARGET] target for modifying conntrack timeout value
> 
> > +                ct->timeout.expires = new_expires;
> >                   ^^^
> >
> > Hm I thought that I told you to use ip_ct_refresh... you should. Your
> > target will look smarter and you can forget about proper locking...
> > which is now completely broken...
> 
> Hi Pablo,
> 
> Thanks for the comments. I made the modification and attached the latest
> copy. Now it uses ip_ct_refresh. The target first reads the existing
> expire value, then modify it. If there is something in between, the expire
> value might get changed. Even worse, the conntrack state might change.
> That's why I locked it first, then read and write, finally unlock. If it
> is broken, there is no difference anyway...
> 

Just wonder if there is any update on this please...

Thanks,
Richard
