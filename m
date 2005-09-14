From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Communication between kernel modules (what's the proper way?)
Date: Wed, 14 Sep 2005 02:11:33 +0200
Message-ID: <43276AB5.8040008@eurodev.net>
References: <a60102c305091310302e9dc215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: bikkit@gmail.com
In-Reply-To: <a60102c305091310302e9dc215@mail.gmail.com>
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

JC wrote:
> Somewhat out of topic for the mailing list, but I guess the developers
> here could advise me on the matter:
> 
> I have developed two modules that use hooks to manipulate packets, and
> I wish for them to communicate with each other. The proper way to
> communicate with userspace is by using ioctls. But what is a proper
> way to use to pass data between the two modules, bearing in mind these
> are my modules and I cant apply for a system call...?

This isn't netfilter related at all, but it's related with kernel
programming.

You could do it by means of kernel notifiers (linux/notifier.h). You can
export a notifier_block that can be used to [un]register callbacks
(notifier_chain_[un]register) by both modules.

--
Pablo
