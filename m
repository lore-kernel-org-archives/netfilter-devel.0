From: Samir Bellabes <sam@synack.fr>
Subject: Re: [RFC v2 00/10] snet: Security for NETwork syscalls
Date: Sat, 06 Mar 2010 19:50:02 +0100
Message-ID: <m2r5nxp9np.fsf@ssh.synack.fr>
References: <1267561394-13626-1-git-send-email-sam@synack.fr>
	<201003030156.o231udx1023055@www262.sakura.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, hadi@cyberus.ca, kaber@trash.net,
	zbr@ioremap.net, nhorman@tuxdriver.com, root@localdomain.pl,
	linux-security-module@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <201003030156.o231udx1023055@www262.sakura.ne.jp> (Tetsuo Handa's
	message of "Wed, 03 Mar 2010 10:56:39 +0900")
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Regarding [RFC v2 05/10] snet: introduce snet_event

> +int snet_event_is_registered(const enum snet_syscall syscall, const u8 protocol)
>
> Maybe rcu_read_lock() is better than rw spinlock because this function is
> frequently called.

Indeed. Evgeniy Polyakov already noticed that, it's on my TODO.
thank you Tetsuo
sam
