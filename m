From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: pre, pre, premangle?
Date: 24 Apr 2003 16:44:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051195490.5930.35.camel@tux.rsn.bth.se>
References: <20030424141625.54286.qmail@web13902.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20030424141625.54286.qmail@web13902.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-04-24 at 16:16, Scott MacKay wrote:
> Hiyas, 
>     Is there any way to hook into incoming packets
> such that you get it before any other investigative
> code (such as conn tracking), examine it, and mangle
> it before letting them work on the packet?

./runme --batch pending
./runme userspace/raw.patch

iptables -t raw -A PREROUTING yada yada

Many of the targets that mangle packets have checks for which table they
are beeing added too and refuse to be added to other tables than mangle.
So to be able to use them in the raw table you will have to modify them
a bit. The raw table is mostly used for DROP-ing, NOTRACK-ing and
TRACE-ing packets.

userspace/raw.patch tries to patch the userspace iptables as well.

-- 
/Martin
