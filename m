From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: problem with flowi structure
Date: Thu, 16 Sep 2010 17:14:39 +0200
Message-ID: <AANLkTi=bGsvMqnTSanA73FhDH_DashmXTcA1sddtj0P6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all. I'm "studying" the flowi structure.
I see some source code:

[CODE]
...
fl.nl_u.ip4_u.saddr = 0
...
ip_route_output_key(....,&fl,....)
...
(where fl is a flowi struct)
[/CODE]

what is the meaning of saddr = 0?


-- 
Nicola Padovano
e-mail: nicola.padovano@gmail.com
web: http://npadovano.altervista.org
