From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Questions
Date: Wed, 12 Nov 2003 22:51:11 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311122248280.4923-100000@filer.marasystems.com>
References: <20031112192618.16434.qmail@mail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xiaonan Lu <zplxn@mail.com>
In-Reply-To: <20031112192618.16434.qmail@mail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 Nov 2003, Xiaonan Lu wrote:

> When my module is hooked and begin to run, I can not use netscape, ssh,
> .etc anymore. The typical result is: I type: ssh <hostname> -l username,
> the machine seems to stop, no any response except I stop my module. It
> seems every IP packet were stop by somebody. In my module, I don't drop
> any packet, for every packet I get, I just record the timestamp and
> return NF_ACCEPT.

Verify your module. The problem is most likely to be found there.

Hint: Debugging kernel modules is very easily done using user-mode-linux 
<urlhttp://user-mode-linux.sourceforge.net/>. This allows you to run and 
debug the kernel as if it was no more than a plain application.

Regards
Henrik
