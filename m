From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: How to change a match options
Date: Thu, 10 Apr 2003 22:09:04 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304102209.04927.fabrice@netfilter.org>
References: <000001c2fdc3$fd33ddc0$0300000a@juan>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <000001c2fdc3$fd33ddc0$0300000a@juan>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Juan,

On Tuesday 08 April 2003 19:42, Juan Torres wrote:
> Hi, I want to make my own match, but before, to understand how it works,
> I'm modifying an existing match, ipt_multiport to be precise, so, I have
> changed the ipt_multiport.c file. But now I want to change the match
> writing options (for example, to add a new option similar than -dport,
> or to make that it wouldn't be necessary to write any option) So I need
> to know which file I have to modify to change the "writing options" of a
> match.

You will find what you're looking for in the netfilter-hacking-HOWTO:
http://www.netfilter.org/documentation/HOWTO/netfilter-hacking-HOWTO.html

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
