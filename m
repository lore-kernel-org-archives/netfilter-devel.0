From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RAM and conntrack performance: first draft of the document is
 online
Date: Thu, 27 Nov 2003 10:56:28 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271053290.21649-100000@filer.marasystems.com>
References: <20031127033351.GC1084@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031127033351.GC1084@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Herve Eychenne wrote:

> Which is really not that much when you have 512 MB... (0.0015 %)

Err... 800K or 512M is .15% which is not insignificant if you do not plan
on using that memory. If each subsytem of the kernel did the same "just in
case" then there would be very little memory left for the user.

Regards
Henrik
