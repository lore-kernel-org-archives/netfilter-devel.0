From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Mon, 31 Oct 2005 08:51:41 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>
References: <Pine.LNX.4.62.0510281303190.11839@bizon.gios.gov.pl>
	<4364E08D.8020402@eurodev.net>
	<Pine.LNX.4.62.0510302240420.22661@bizon.gios.gov.pl>
	<436592AA.6040202@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-101973709-1130745101=:8000"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <436592AA.6040202@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-101973709-1130745101=:8000
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 31 Oct 2005, Pablo Neira wrote:
<CUT>
>> PS: Would you find some time to look at=20
>> http://bugzilla.kernel.org/show_bug.cgi?id=3D5438
>
> Can you still trigger that oops with the current working copy from SVN?

IMHO this is a kernel bug. And to be clear: there is no problem with new=20
version of userspace application/libraries.

The problem apperas only with _old_ library. There were a lot of API=20
changes and probably kernel does not properly validate user data=20
(boudaries?).


Best regards,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-101973709-1130745101=:8000--
