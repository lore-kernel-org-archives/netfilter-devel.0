From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK: targinfosize 8 != 4
Date: Wed, 14 Dec 2005 01:27:49 +0100
Message-ID: <439F6705.1000700@trash.net>
References: <00fe01c5ffb5$f0a7cf20$455f030a@askeyrd3>	<20051213091820.GA1021@DervishD>
	<439EB826.3070002@trash.net>
	<200512131809.jBDI9lAW028466@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Jones Desougi <jones@ingate.com>
In-Reply-To: <200512131809.jBDI9lAW028466@usagi.ingate.se>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Jones Desougi wrote:
>>That can't be the reason, all revisions of a single match/target are
>>in the same object file and the supported revision is (supposed to be)
>>probed. Salim, can you send a strace of the failing iptables command?
> 
> 
> The key being "supposed to be". :-)

I somehow expected something like this :)

> Try the patch below. (It's bug #413 in bugzilla)

This looks good, thanks. I'm going to apply it as soon as
there is confirmation that it really fixes the problem
people are seeing.
