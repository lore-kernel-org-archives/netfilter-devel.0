From: David Cannings <lists@edeca.net>
Subject: Re: taking related connections to the limit
Date: Thu, 4 Mar 2004 22:29:14 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403042229.14348.lists@edeca.net>
References: <20040304120402.GH14383@magicbluesmoke.net>
Reply-To: david@edeca.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John P. Looney" <valen@tuatha.org>,
 netfilter-devel@lists.netfilter.org
In-Reply-To: <20040304120402.GH14383@magicbluesmoke.net>
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

On Thursday 04 March 2004 12:04, John P. Looney wrote:
>  Hi, I was wondering if netfilter can do the following:
>
>  If a packet has dest ip X, dport 110, do a DNAT --to IP Y, record the
> SRC IP If a subsequent packet comes into dest IP X, from that SRC IP,
> --dport 25 from the same IP, DNAT --to IP Y also.
>
>  This is to do some work with POP-before-smtp, if you wondered why such
> a demented thing would be needed.

I am not sure whether it can be done or not but remember that they would 
only have to connect in order to be allowed subsequent access to your 
SMTP server.  netfilter obviously cannot handle authentication for POP3 
so will never know whether the user was successful in their connection 
attempt.  Normally, POP before SMTP is based on their username/password 
being entered successfully to POP, which allows later access to SMTP.

Personally I've always found authenticated SMTP to be a better 
alternative.  It means I can give only selected POP users access to SMTP 
and also I can give non POP users access, if need be.

Just something so think about, perhaps.

David
