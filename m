From: Patrick Schaaf <bof@bof.de>
Subject: Re: detecting if compiled or loaded modules
Date: Sun, 15 Dec 2002 13:30:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021215123038.GA22276@oknodo.bof.de>
References: <20021215053701.15581.32963.Mailman@kashyyyk> <20021215133954.70ad328c.24@k0n.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 24 <24@k0n.org>
Content-Disposition: inline
In-Reply-To: <20021215133954.70ad328c.24@k0n.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

>Is there a way to determine if one of the Netfilter Configs is loaded
>as module or built-in in the kernel?

Have a look at /proc/ksyms. But that's not portable, probably not even
to the future 2.6 kernel.

There is no other way. Normal, sane people don't need a GUI to load
their modules. Their init scripts do it for them already. So, there is
no pressing need, especially for an iptables specific solution.

The best you can probably do, is just try to load the module, and ignore
the error case which says "already loaded". Talk to the insmod maintainers
if you have trouble with detecting that error case properly.

best regards
  Patrick

-- 
Who runs GUI programs as root, anyway?
