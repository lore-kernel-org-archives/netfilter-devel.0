From: macadanet@yahoo.es
Subject: netfilter http request filter patch
Date: Tue, 29 Apr 2003 10:32:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <767034681.20030429103220@yahoo.es>
References: <1444106507.20030428121142@yahoo.es>
Reply-To: macadanet@yahoo.es
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------AE11D122812C7BC"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lista de correo netfilter <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1444106507.20030428121142@yahoo.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

------------AE11D122812C7BC
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit




        I send you this mail with a NETFILTER patch made for me.
        This patch (http request filter) find in a http request,
        bad and dangerous http request like nimda, red code,
        unicodes attacks. Then this patch drop, log ,etc. this packet.
        
        my patch is finished but i want your opinion about this.

        How to use httpr?

                    FORWARD                                                                   LOG
        iptables -A INPUT -p tcp --dport 80 -m httpr --httpr '"GET"?"default.ida?"?[XN0]*' -j DROP
                                                               (Regular Expresion)

        I would like that this patch is inserted in de NETFILTER patch
        list.


        I look forward to heaving from you.


       best regards.

       PD: Sorry for my English.

       macada.
------------AE11D122812C7BC
Content-Type: application/octet-stream; name="httpr(patch).tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="httpr(patch).tar.bz2"

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


------------AE11D122812C7BC
Content-Type: application/octet-stream; name="httpr(userspace).tar.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="httpr(userspace).tar.bz2"

QlpoOTFBWSZTWYzPw2kAAbvfkPw0f/f/n3+v3+7/7//+AEAgCFAFeNhtjJr1dzO1zhy0hKIjQnoV
PwmmkT9UybQmMiMhtQAAMjaRmKYgBJFGRMqfgVPZFPUNNpND9UAAZBo9QAAAAASJE01MmqbUDRvV
NNMj1NGQABoxDRoAAGgA4Gg0yGmjQwgZDQwRoaZNGgGQYgADQSRBCniao8U8amp6jyT1ADQaAGgA
aAAAek3vn/liXEKxJGVCbQwbSYKRexD/TCJRDYxjbaTbaPp/MdJmua8iCMhbJw4IbVHJ0moexYOI
E5gGSOFeU0dOLmarIF7Lvb61cwstbTMzYPcgqQWfWznmgHSbJ0BjuukCoSNIMhRalwbmT1e2GNwp
LwMSW2huG7NyNTM2EujanhnH50Fhbn4kP1JFpIkaRwYubv0I9ZhmKgRY6URb8tdMn718KoUQWtN6
u+7XtrgprWi/Hpr6YHM42ESrgc2Zu7eCRIkCZUC8vci95eVTe63EkjJntYPGUyLJGUQSNJborr1j
okFpkbN1UsnOg7rUtAy4lu13nrde14k803Ep524Ok/rJKOz+Z8ydEwyms6T04ZVzkY7cjLDA1k0C
JS9JB5X0YvuPAaf1kjliCU68kJSuxebtU0sYz5QTN3SMrItkK4MclxO9xBA9znhWcaIqIjF8CiMs
Y1Q5nmXmsrwS2rRBU6qKxurFNNerwsudgfjxOJHbRD2occKbVs1QX7lFFFg9wYp8ETpZncUETfBZ
OstfCzVS6IZmaHd8xm/ZsXm6GoqrfrKPDuWbU9QlvbpC06xkzy3DnDukb2Frq02UqUmTGZdTVx1q
sV2zHDwELUTfZDE8E+f8Zr3TDlQwIJt5zsMRnOF+czDMvQwjW/lTPpJho8hcihoICcNJZkTRH0SR
6BilRz6YlKpSEuz1EdB9ro3hTTjLAgVaSJIEL3sMQq4gwUHADCOAYWgwklelD47V1vRw/fJvu5eR
cdhrbHVhOS05yYQoQW9OB5T1hjeC8TMyDPQN/PNOLtJFDLgXBwxMAV7yP+h2P+uUH2TT8uSFE1Y3
VIMQaqIl6MQzPqNTxyUrgM0PCHYez7OItGMLRwKU5pSGQpzGoXSITkXqhgppAUOBvIsPsILCqVWN
EQMcP7o8d9Err3GWVGe9J2Zn2oYnJh0fhKPMOzvCEpdTxyIW3opnmmiV1LDaYLC1T8ZSlyC2t8xp
aM/Kir+HSq7YGzOjMGwvkoxOt9ON1dp6BA9ZTASsZC2zPGCLHFEJGTWLIwAyTBtXJ0rrthBYpmI7
o1W2rK7zqOIgtA+ZEuVFZs4UzT0El9COIhMnwaaETdlClEso1mjQ3IJ0RLVDVWEWWTRSNBHKJM8W
bmVa2WLE5YRRnuHQsSwlTJE6Tuso1CY2FRdlTUCewrYlf+qqjSUoemPbJwKYcfYz5OQhuYekJEnc
nnhwOpfFzhn9WBJtItLIMUUzcMmYJgibQla15M2WwsQxWJBeJlqZIypYm1NPQ6C6c6TWIyERRYcV
GdtOnvYA7Lb2Eu3dzZM1K44gxBc23ovC/CPlxJEqKB2CUqUkMgwDmOFVy5CZmUBgyqCs11sxXFSD
tzSSoQeRnKtCyFBSMwMBF1IQtmiQ8B80InHtH0zKqB52opuwxr0xFroRYWKikYlFQI3CC0sG6jKv
9OurNGKDO+r+5v3bDpu4MhouVySY2W5MsGJWNtAMM4sbNCZIgPCCIaM2V0TGFNMgvQwUiKCEmBFJ
oitSWjkChgq1ESrcMZeMoTxSLgQoVCkw1qRNZ6hBaA3DZSo9c2gx48ChuayxFxu1k9URrVFAyySS
zWDmOJiMXLrdDQMqqKWEzXu3EMD5Sg2d9i/4u5IpwoSEZn4bSA==


------------AE11D122812C7BC--
