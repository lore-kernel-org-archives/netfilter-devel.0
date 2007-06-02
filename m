From: Patrick McHardy <kaber@trash.net>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Sat, 02 Jun 2007 14:55:16 +0200
Message-ID: <466168B4.7020103@trash.net>
References: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
	<46603E2B.8080503@trash.net>
	<Pine.LNX.4.61.0706021445130.21057@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Mike Accetta <maccetta@laurelnetworks.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706021445130.21057@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=7716
> 
> Software error:
> 
> DBD::mysql::st execute failed: Unknown column 'products.classification_id' in
> 'where clause' [for Statement "SELECT products.name, classifications.name FROM
> products, classifications WHERE classifications.id = products.classification_id
> ORDER BY classifications.name"] at Bugzilla/DB.pm line 84
> 	Bugzilla::DB::SendSQL('SELECT products.name, classifications.name FROM
> products, cla...') called at globals.pl line 140
> 	main::GenerateVersionTable() called at globals.pl line 312
> 	main::GetVersionTable() called at
> /var/www/bugzilla.netfilter.org/htdocs/bugzilla/show_bug.cgi line 60
> 
> For help, please send mail to the webmaster (webmaster@netfilter.org), giving
> this error message and the time and date of the error. 
> 
> Sat Jun  2 14:46:26 CEST 2007


Well, gentoo is a pile of crap.
