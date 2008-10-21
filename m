From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Tue, 21 Oct 2008 23:32:52 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0810212328200.30799@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu> <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl> <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-1464768849-1224624772=:30799"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-1464768849-1224624772=:30799
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 21 Oct 2008, Jozsef Kadlecsik wrote:

> On Tue, 21 Oct 2008, Krzysztof Oledzki wrote:
>
>> # element separator token changed to ',' in anticipating IPv6 addresses, old
>> separator tokens are still supported
>>
>> # cat  aqq
>> -N aqq macipmap --from 1.2.3.1 --to 1.2.3.10
>> -A aqq 1.2.3.10,11:22:33:44:55:66
>> COMMIT
>>
>> # cat aqq|ipset -R
>> Warning: please replace old separator character ':22:33:44:55:66.1' with ','.
                                                                    ~~
Just one more note: this ".1" looks strange, is it intentionally? It comes
from:

fprintf(stderr, "Warning: please replace old separator character '%s.1' with ','.\n"
 		"Next release won't support it.\n",
 	ptr);

Maybe insted of '%s.1' something like '%c' should be used here, to print 
only one character - the deprecated separator?

Best regards,

 				Krzysztof Olêdzki
---1144830174-1464768849-1224624772=:30799--
