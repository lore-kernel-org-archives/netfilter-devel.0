From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [FUN] New target: passive OS fingerprinting.
Date: Mon, 24 Nov 2003 14:26:00 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031124142600.69dac294.johnpol@2ka.mipt.ru>
References: <20031124020436.334cf2c6.johnpol@2ka.mipt.ru>
	<20031124101806.GI4888@obroa-skai.de.gnumonks.org>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031124101806.GI4888@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 24 Nov 2003 11:18:06 +0100
Harald Welte <laforge@netfilter.org> wrote:

Hi, Harald.

> On Mon, Nov 24, 2003 at 02:04:36AM +0300, Evgeniy Polyakov wrote:
> > New target which trying to determine(by passive fingerprinting) 
> > remote OS by set of parameters from initial SYN packet which was
> > sent to us.
> 
> why an additional target?  I don't think it's a good idea to
> copy+paste all that code.  
>
> You could maybe add a '--log' option to the match or whatever... but I
> really don't think it's a good idea to have the same code replicated
> as match and as target.

Yep, but this target was created for convenient logging.
For example, if we only want to know, what OSes connecting to our
server. And we can't use match, since we don't know in advance, what OS
will connect to us. So we must enter --genre Linux, --genre OpenBSD,
--genre AIX and so on...

Or do you propose new option for OSF match( --log), that will make OSF
logs all corresponding fingerprints even if they will not match desired
genre? That is defenitely good idea.


> -- 
> - Harald Welte <laforge@netfilter.org>            
> http://www.netfilter.org/

	Evgeniy Polyakov ( s0mbre )
