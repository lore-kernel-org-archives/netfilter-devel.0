From: Serge Droz <serge.droz@psi.ch>
Subject: Re: Feasability of Protocol Filtering
Date: Fri, 25 Apr 2003 11:36:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA901AB.2080301@psi.ch>
References: <Pine.LNX.4.44+maildir.0304230816280.20974-100000@woozle.org> <3EA7026D.2010101@uni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <e.friedrich@uni.de>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <3EA7026D.2010101@uni.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Eicke Friedrich wrote:
> 
> i'm doing a quite similar thing at the moment: i'm developing a match 
> that recognizes p2p traffic (kazaa, edonkey finished but more to come) 
> by their protocol and mark them. After that i use a tc filter to read 
> the marks and put the packets in QoS classes.
> What you need is something characteristic for every protocol. For 
> example: every kazaa-download starts with a packet containing the string 
> "GET /.hash=" - i do a string-match on each packet and if i find a match 
> i just mark the whole connection with CONNMARK.
So, if by chance this message got split exactly at the right place so 
you'd get a packet witch starts with "GET /.hash=" you couldn't post 
this anymore. Your idea will work 99.9% (say), but you can't aford a 
single missmatch or you kill a legitimate connection (which for sure 
will have been initiated by your boss :-))

You can easily try this out: write a snort filter that captures this 
traffic and see how many false positives you get.

Cheers
Serge


-- 
Serge Droz
Paul Scherrer Institut                mailto:serge.droz@psi.ch
CH-5232 Villigen PSI                   Phone: ++41 56 310 3637
                                          Fax: ++41 56 310 3649
