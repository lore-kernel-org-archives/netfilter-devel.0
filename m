From: Scott MacKay <scottmackay@yahoo.com>
Subject: pre, pre, premangle?
Date: Thu, 24 Apr 2003 07:16:25 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030424141625.54286.qmail@web13902.mail.yahoo.com>
References: <1051188908.28409.39.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1051188908.28409.39.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hiyas, 
    Is there any way to hook into incoming packets
such that you get it before any other investigative
code (such as conn tracking), examine it, and mangle
it before letting them work on the packet?

-Scott

__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
