From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: regular expressions - how to
Date: Sun, 9 Feb 2003 22:42:08 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302092242.08611.fabrice@netfilter.org>
References: <18022761969.20030208171208@yahoo.es>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: macadanet@yahoo.es,
   lista de correo netfilter <netfilter-devel@lists.netfilter.org>
In-Reply-To: <18022761969.20030208171208@yahoo.es>
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


Hola,

On Sunday 09 February 2003 00:12, macadanet@yahoo.es wrote:
> Hello group,
> I want to develop a patch for netfilter (kernel 2.4.20). I want compare
> many strings in a packet. I didn't find a kernel library to work in this
> project.
> With regular expresions I want to find strings in a packet. Anybody
> can helps me?

I'm afraid some people have previously proposed the same thing on this list
sometime around last year, and the reply was generally that it was a bad idea.
Regexps are _very_ heavy/time consuming, and should generally not be in the kernel..
I believe I won't be the only one to tell you this :)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
