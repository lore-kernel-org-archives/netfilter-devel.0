From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [RFC][0/2] New netfilter match module
Date: Fri, 2 Jun 2006 23:55:25 -0700 (PDT)
Message-ID: <20060603065525.9380.qmail@web50212.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

At some point in the not-too-distant past, Amin Azez wrote:
>Specially, however, could you not solve it using ! with a rule like:
>
>iptables -t nat -A PREROUTING -p tcp -s ! 10.18.0.0/24 --dport 80 \
>         -j DNAT --to-destination <webserver address>
No traffic from the private network will get routed with this rule, which is not
what I want.


>iptables -t nat -A PREROUTING -j try_80
>iptables -t nat -A try_80 -p tcp -s 10.18.0.0/24 -j RETURN
>iptables -t nat -A try_80 -p tcp -s 10.18.20.0/24 -j RETURN
>iptables -t nat -A try_80 -p tcp --dport 80 -j DNAT --to-destination <webserver address>
Same as above.


-Alex

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
