From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 01:06:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403240105250.15222-100000@filer.marasystems.com>
References: <20040323162352.78749.qmail@web13904.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040323162352.78749.qmail@web13904.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 23 Mar 2004, Scott MacKay wrote:

> I wanted to mark up packets with information as they pass thru the
> system. Basically, I want to associate some data with a packet during
> PREROUTING/raw (to read info prior to conntrack) and then get that
> information back during PREROUTING/mangle.  Is there a module already
> written which could perform this?

MARK should be able to do this.

> It is not something I would need to have accessible to the iptables
> program, though I will probably need to adjust some code to make it
> accessible to my ip_queue userspace application...

The MARK value is available (read-only) via ip_queue.

Regards
Henrik
