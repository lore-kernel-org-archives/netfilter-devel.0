From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Classifying packets with the CLASSIFY Target
Date: Mon, 5 Jul 2004 15:14:17 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407051212.i65CC8MX001686@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407051204230.24656-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407051204230.24656-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I went through some examples on creating root handles and classes attached
to these handles. What I understand is that even when using the CLASSIFY
target, I still have to create these handles and classes? Am I right?
Regards,

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami
-----Original Message-----
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Henrik
Nordstrom
Sent: Monday, July 05, 2004 1:10 PM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: Re: Classifying packets with the CLASSIFY Target

On Mon, 5 Jul 2004, Muhammad R. Sami wrote:

> Now as the author states that the above command "Classifies packets of an
> established session between 40 and 100 bytes", I would like to ask what
does
> 1:10 exactly mean.

It is a classid within the Linux traffic shaper class hierarchy, defined
by using the tc command.

See the Linux traffic shaping howto and related documentation on how to 
define traffic shaper classes.

Using the CLASSIFY target in iptables is an alternative method of 
classifying packets for the Linux traffic shaper, complementing the 
tc filter scheme.

Regards
Henrik
