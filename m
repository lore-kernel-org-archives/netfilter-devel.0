From: Patrick McHardy <kaber@trash.net>
Subject: Re: Minor modification of function dcc_parse in ip_conntrack_irc.c
Date: Wed, 11 Aug 2004 15:29:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411A1F1D.7080804@trash.net>
References: <1092170081.9955.12.camel@dana.go-nix.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Nix N. Nix" <nix@go-nix.ca>
In-Reply-To: <1092170081.9955.12.camel@dana.go-nix.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Nix N. Nix wrote:

>Hi!
>
>The dcc_parse function in ip_conntrack_irc.c has a shortcoming:
>
>\1DCC <command> <param> <ip> <port> [<size>]\1\n
>
>...is the format of a DCC command (where <size> is optional).
>
>dcc_parse is responsible for finding the ip and port in this string.  It
>gets the string starting at <param>.  Unfortunately, so far, dcc_parse
>assumed that <param> does not contain any spaces.  Thus, the module
>failed to track connections implied by a string of the form
>
>\1DCC SEND "The Big Movie.avi" 10289477 1011 37546262\1\n
>
>I have remedied this problem by having it check whether there's a double
>quote and, if so, loop on to the corresponding closing double quote
>before resuming normal processing:
>  
>
How do filenames which contain a quotation mark look ? I assume the 
quotation
marks is escaped ? We should also handle this case.

Regards
Patrick
