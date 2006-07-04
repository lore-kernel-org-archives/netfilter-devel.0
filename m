From: Patrick Schaaf <bof@bof.de>
Subject: Re: patch for rule insert
Date: Tue, 4 Jul 2006 07:38:00 +0200
Message-ID: <20060704053800.GB29616@oknodo.bof.de>
References: <44A9E239.8080403@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
Content-Disposition: inline
In-Reply-To: <44A9E239.8080403@rocsys.com>
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

>                I would loke to know if any of you have  a patch for 
> inserting rule anywhere in the middle of the chain.
>                That is with -A we append the new rule and -I we add the 
> new rule to the top of the chain. So i wold like to insert it in middle 
> of the chain. Is it possible?

Look at the manpage / iptables --help output. Notice that the
options -I, -R, and -D take a 'rulenum' argument (optional for -I).
Also note that '-L --line-numbers' gives you such rulenums, if you
don't want to count the rules by yourself.

Patrick
