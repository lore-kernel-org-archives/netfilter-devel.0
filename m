From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Sat, 2 Jun 2007 14:45:34 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706021445130.21057@yvahk01.tjqt.qr>
References: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
	<46603E2B.8080503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Mike Accetta <maccetta@laurelnetworks.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46603E2B.8080503@trash.net>
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


On Jun 1 2007 17:41, Patrick McHardy wrote:
>>>>
>>>>iptables -A  OUTPUT -p tcp --destination-port 23 \
>>>>--destination 10.0.20.1  -j REJECT --reject-with tcp-reset
>>>
>>>I cannot reproduce this with 2.6.20.2. Have you tried any newer kernel?
>> 
>> This was filed as Bugzilla #7716 and fixed by Patrick McHardy in 2.6.20.
>
>The patch was also sent to -stable, I think its in 2.6.19.3.

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=7716

Software error:

DBD::mysql::st execute failed: Unknown column 'products.classification_id' in
'where clause' [for Statement "SELECT products.name, classifications.name FROM
products, classifications WHERE classifications.id = products.classification_id
ORDER BY classifications.name"] at Bugzilla/DB.pm line 84
	Bugzilla::DB::SendSQL('SELECT products.name, classifications.name FROM
products, cla...') called at globals.pl line 140
	main::GenerateVersionTable() called at globals.pl line 312
	main::GetVersionTable() called at
/var/www/bugzilla.netfilter.org/htdocs/bugzilla/show_bug.cgi line 60

For help, please send mail to the webmaster (webmaster@netfilter.org), giving
this error message and the time and date of the error. 

Sat Jun  2 14:46:26 CEST 2007



	Jan
-- 
