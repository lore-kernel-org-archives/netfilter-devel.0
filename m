From: Scott MacKay <scottmackay@yahoo.com>
Subject: Adding packet metadata
Date: Tue, 23 Mar 2004 08:23:52 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040323162352.78749.qmail@web13904.mail.yahoo.com>
References: <Pine.LNX.4.44.0403172230510.11069-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403172230510.11069-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
I wanted to mark up packets with information as they
pass thru the system.  Basically, I want to associate
some data with a packet during PREROUTING/raw (to read
info prior to conntrack) and then get that information
back during PREROUTING/mangle.  Is there a module
already written which could perform this?  It is not
something I would need to have accessible to the
iptables program, though I will probably need to
adjust some code to make it accessible to my ip_queue
userspace application...

-Scott

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
