From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: FW: Questions about Iptable extensions
Date: Wed, 9 Jun 2004 23:36:11 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406092330550.7851-100000@filer.marasystems.com>
References: <4807CA09ACACCF4BBDACF1EF2455D8B3AB8DC4@bbserver3.backbonesecurity.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Shannon J. Field" <shannon.field@backbonesecurity.com>
In-Reply-To: <4807CA09ACACCF4BBDACF1EF2455D8B3AB8DC4@bbserver3.backbonesecurity.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 9 Jun 2004, Shannon J. Field wrote:

> I was attempting to compile sample code from this tutorial:
> 
> http://www.netfilter.org/documentation/tutorials/lw-2000/tut-6.html

This sample code apparently needs some minor corrections. Not to 
unexpected in 4 years..

> libipt_length.c: In function `parse':
> libipt_length.c:48: too few arguments to function `string_to_number'

The string_to_number function needs to be called like

   if (string_to_number(argument, max, min, &result) == -1) {
	/* invalid argument.. 
   }

see any of the existing modules in the extensions directory for samples.

> 	libipt_length.c:51: `s' undeclared (first use in this function)

This is a pure C programming error.. I think this should be 
argv[optind-1], or maybe there should be a "char *s" variable defined and 
assigned to the same..

> 	libipt_length.c:39: warning: unused variable `info'
> 	libipt_length.c: In function `print_length':
> 	libipt_length.c:74: structure has no member named `length'

And these two is also self-explanatory.

Regards
Henrik
