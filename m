From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: parse_interface and argv[optind-1] argument?
Date: Fri, 2 Apr 2004 10:52:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404021046320.18505-100000@filer.marasystems.com>
References: <406D2750.5050705@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <406D2750.5050705@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2 Apr 2004, Ozgur AKAN wrote:

> I could not find the value of first argument of the funciton below which 
> is in iptables.c file.
> 
> static void parse_interface(const char *arg, char *vianame, unsigned 
> char *mask)
> 
> "const char *arg" takes value of "argv[optind-1]". Is "argv[optind-1] " 
> releated with modules/names?

argv[optind-1] is the current command line argument being processed.

Why the code is written in this manner instead of using optarg (with 
update in check_inverse) I do not know.

Regards
Henrik
