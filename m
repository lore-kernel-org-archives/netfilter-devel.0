From: Allen Francom <aef@tempest.prismnet.com>
Subject: Re: Netfilter as an application
Date: Fri, 16 Jan 2004 14:06:03 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040116140423.I69847@tempest.prismnet.com>
References: <20040116194705.905.qmail@web40302.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kernel_learner <kernel_learner@yahoo.com>
In-Reply-To: <20040116194705.905.qmail@web40302.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Um...

One way or another I think the "user" will at least
have to have "root" privileges.

Netfilter I don't think will do what you want, I think
it is totally dependent on the kernel.

You might look at Snort.  www.snort.org

-AEF

On Fri, 16 Jan 2004, kernel_learner wrote:
>  How's it going! I am looking for something that I am
> not sure currently exists. Basically I want to make a
> version of netfilter that's free from all the
> kernel-level and networking stack hooks. I am looking
> for a plain simpler version of netfilter which does
> not interact with the kernel or the networking stack
> in any way. It would be a standard user program which
> a person with normal privelges could compile and run.
