From: Patrick Schaaf <bof@bof.de>
Subject: Re: urgent help on libiptc
Date: Sun, 9 Mar 2003 20:23:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030309192348.GA7177@oknodo.bof.de>
References: <20030309190618.11970.qmail@web41007.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: teddybear4u@sify.com
Content-Disposition: inline
In-Reply-To: <20030309190618.11970.qmail@web41007.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> There is no tutorial connecting those two topics.

This is because libiptc is not really thought of as a useful library
to develop other applications; it's an internal detail of the current
iptables implementation.

If you need to integrate other applications with iptables, you are
supposed to call the iptables, iptables-save, and iptables-restore
programs, and let them worry about the details.

Any program you write now to work with libiptc, is bound to fail
some time in the not so far future, when the next rewrite of firewalling
happens. This is already in the works, and as far as I know, there will
be no attempt at library backwards compatibility.

best regards
  Patrick
