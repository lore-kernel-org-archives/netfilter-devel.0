From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: problem with libipq and userprocess and 'clean' exit
Date: Thu, 13 Jun 2002 13:56:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206131356.23597@henrik.marasystems.com>
References: <Mutt.LNX.4.44.0206132148020.5321-100000@blackbird.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: James Morris <jmorris@intercode.com.au>
In-Reply-To: <Mutt.LNX.4.44.0206132148020.5321-100000@blackbird.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thursday 13 June 2002 13:50, James Morris wrote:

> Nothing to worry about, there is currentl no way for the ip_queue
> module to know that the user process has exited (unless another
> process starts using the queue).
>
> The kernel module also ensures that all packets are fed back into
> the stack, no matter what the userspace application does.

So one way to get out of the situation is to remove the QUEUE target 
to stop new packets from being queued, and then start a dummy program 
that attaches to the queue? This should both stop new packets from 
being queued and release any pending packets, right?

Regards
Henrik
