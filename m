From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: IDEA FOR NEW TARGET
Date: Mon, 28 Oct 2002 19:15:57 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210281911500.14681-100000@dns.toxicfilms.tv>
References: <1035739609.3dbc21d967912@student-webmail.lboro.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: C.Shelley-02@student.lboro.ac.uk
In-Reply-To: <1035739609.3dbc21d967912@student-webmail.lboro.ac.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I do not feel it is a necessary solution, just construct proper ACLs which
would allow your source address in.
Mangling/demangling tcp flags may cause problems, imagine there is a
firewall on route from your mangling to the demangling machine. It may
consider eg. mangled SYN packets to ACK packets, as invalid due to its
statefullness machanism or something similar to the tcp-window-tracking.

The idea for the target could still find its other uses, but i wouldn not
use this technique to overcome ACLs.

Regards,
Maciej Soltysiak
