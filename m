From: "Andrew Smith" <nfml@k1k2.com>
Subject: Re: cttest-0.1
Date: Sat, 6 Jul 2002 16:10:01 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
In-Reply-To: <20020705165354.GD3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> 2002-07-05 18:54:15+0200, Patrick Schaaf <bof@bof.de> ->
>> 
>> - make the hash bucket count at least individible by 2. This should go
>>   as a strong suggestion into the documentation, and should be
>>   implemented in the default initialization code. Anybody volunteering
>>   for one or the other? I'll do the code part, but I won't do the
>>   docs.
> 
> Well, I think we even can force people to use an odd count.
> 
> if (hashsize%2 == 0)
> 	hashsize--;
> 
> 
> -- 
> /Joakim Axelsson A.K.A Gozem@EFnet & OPN

Just so you don't underestimate a requirement ... :-)

if ((hashsize & 1) == 0)
	hashsize++;

(assume we are checking positive numbers ;-)

-- 
-Cheers
-Andrew

MS ... if only he hadn't been hang gliding!
