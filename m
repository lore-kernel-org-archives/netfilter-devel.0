From: kernel_learner <kernel_learner@yahoo.com>
Subject: Re: Netfilter as an application
Date: Fri, 16 Jan 2004 13:47:21 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040116214721.82710.qmail@web40301.mail.yahoo.com>
References: <20040116140423.I69847@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Allen Francom <aef@tempest.prismnet.com>
In-Reply-To: <20040116140423.I69847@tempest.prismnet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks Allen,

 However I am not sure why you think user should have
user priveleges. I am not saying I will use netfilter
as it is. I am thinking of modifying netfilter so that
I can use it as a user application just for
demonstration purposes. I just need some initial
guidance to start off in the right direction:

What exactly does the netfilter use from the Linux
kernel?

Where exactly does it interact with the kernel? 

I am wading through the source code right now but I am
unable to find those exact points.

Most of the extensions are modules..which is fine..I
can easily convert them to user-application-code.

I hope I am making myself clear...

_LEARNer



--- Allen Francom <aef@tempest.prismnet.com> wrote:
> 
> Um...
> 
> One way or another I think the "user" will at least
> have to have "root" privileges.
> 
> Netfilter I don't think will do what you want, I
> think
> it is totally dependent on the kernel.
> 
> You might look at Snort.  www.snort.org
> 
> -AEF
> 
> On Fri, 16 Jan 2004, kernel_learner wrote:
> >  How's it going! I am looking for something that I
> am
> > not sure currently exists. Basically I want to
> make a
> > version of netfilter that's free from all the
> > kernel-level and networking stack hooks. I am
> looking
> > for a plain simpler version of netfilter which
> does
> > not interact with the kernel or the networking
> stack
> > in any way. It would be a standard user program
> which
> > a person with normal privelges could compile and
> run.
> 


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
