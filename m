From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_queue question
Date: Sun, 22 Feb 2004 16:55:11 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402221652280.17860-100000@filer.marasystems.com>
References: <20040220225156.40182.qmail@web13422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ahmad Almulhem <feltah@yahoo.com>
In-Reply-To: <20040220225156.40182.qmail@web13422.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004, Ahmad Almulhem wrote:

> I am trying to run 2 program to
> use ip_queue module at the same time. 

There can only be one program accepting ip_queue packets at a time. This 
since there is no way for the kernel to indicate which of the two should 
get the packet or be allowed to set the verdict so it is limited to one 
program.

> "Received error message 16"

EBUSY           16      /* Device or resource busy */



If you have a different opinion on how ip_queue should operate to support
more than one queue handler then please elaborate on how you think this 
should work.

Regards
Henrik
