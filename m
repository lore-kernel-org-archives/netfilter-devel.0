From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Wed, 17 Mar 2004 17:34:06 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040318013406.6848.qmail@web13911.mail.yahoo.com>
References: <Pine.LNX.4.44.0403180152360.18641-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403180152360.18641-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Just curious, having made my own decision to not use
the kinda-interfaces and just call the provided
iptables executables; has anyone run valgrind
(http://valgrind.kde.org/) on iptables?  I did a
simple one like:

valgrind --leak-check=yes iptables -A PREROUTING -t
mangle -s 192.168.1.0/24 -j DROP

and got a few...I would be cautious about using these
routines in a long-running app unless they were looked
at more.



__________________________________
Do you Yahoo!?
Yahoo! Mail - More reliable, more storage, less spam
http://mail.yahoo.com
